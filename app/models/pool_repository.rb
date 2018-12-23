# frozen_string_literal: true

# The PoolRepository model is the database equivalent of an ObjectPool for Gitaly
# That is; PoolRepository is the record in the database, ObjectPool is the
# repository on disk
class PoolRepository < ActiveRecord::Base
  include Shardable
  include AfterCommitQueue

  has_one :source_project, class_name: 'Project'
  validates :source_project, presence: true

  has_many :member_projects, class_name: 'Project'

  after_create :correct_disk_path

  state_machine :state, initial: :none do
    state :scheduled
    state :ready
    state :failed
    state :obsolete

    event :schedule do
      transition none: :scheduled
    end

    event :mark_ready do
      transition [:scheduled, :failed] => :ready
    end

    event :mark_failed do
      transition all => :failed
    end

    event :mark_obsolete do
      transition all => :obsolete
    end

    state all - [:ready] do
      def joinable?
        false
      end
    end

    state :ready do
      def joinable?
        true
      end
    end

    after_transition none: :scheduled do |pool, _|
      pool.run_after_commit do
        ::ObjectPool::CreateWorker.perform_async(pool.id)
      end
    end

    after_transition scheduled: :ready do |pool, _|
      pool.run_after_commit do
        ::ObjectPool::ScheduleJoinWorker.perform_async(pool.id)
      end
    end

    after_transition any => :obsolete do |pool, _|
      pool.run_after_commit do
        ::ObjectPool::DestroyWorker.perform_async(pool.id)
      end
    end
  end

  def create_object_pool
    object_pool.create
  end

  # The members of the pool should have fetched the missing objects to their own
  # objects directory. If the caller fails to do so, data loss might occur
  def delete_object_pool
    object_pool.delete
  end

  def link_repository(repository)
    object_pool.link(repository.raw)
  end

  # This RPC can cause data loss, as not all objects are present the local repository
  def unlink_repository(repository)
    object_pool.unlink_repository(repository.raw)

    mark_obsolete unless member_projects.where.not(id: repository.project.id).exists?
  end

  def object_pool
    @object_pool ||= Gitlab::Git::ObjectPool.new(
      shard.name,
      disk_path + '.git',
      source_project.repository.raw,
      source_project.path_with_namespace)
  end

  def inspect
    "#<#{self.class.name} id:#{id} state:#{state} disk_path:#{disk_path} source_project: #{source_project.full_path}>"
  end

  private

  def correct_disk_path
    update!(disk_path: storage.disk_path)
  end

  def storage
    Storage::HashedProject
      .new(self, prefix: Storage::HashedProject::POOL_PATH_PREFIX)
  end
end
