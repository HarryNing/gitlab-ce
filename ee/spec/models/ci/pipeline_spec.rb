require 'spec_helper'

describe Ci::Pipeline do
  let(:user) { create(:user) }
  set(:project) { create(:project) }

  let(:pipeline) do
    create(:ci_empty_pipeline, status: :created, project: project)
  end

  it { is_expected.to have_one(:chat_data) }

  describe '.failure_reasons' do
    it 'contains failure reasons about exceeded limits' do
      expect(described_class.failure_reasons)
        .to include 'activity_limit_exceeded', 'size_limit_exceeded'
    end
  end

  PIPELINE_ARTIFACTS_METHODS = [
    { method: :codeclimate_artifact, options: [Ci::Build::CODEQUALITY_FILE, 'codequality'] },
    { method: :performance_artifact, options: [Ci::Build::PERFORMANCE_FILE, 'performance'] },
    { method: :sast_artifact, options: [Ci::Build::SAST_FILE, 'sast'] },
    { method: :dependency_scanning_artifact, options: [Ci::Build::DEPENDENCY_SCANNING_FILE, 'dependency_scanning'] },
    { method: :license_management_artifact, options: [Ci::Build::LICENSE_MANAGEMENT_FILE, 'license_management'] },
    # sast_container_artifact is deprecated and replaced with container_scanning_artifact (#5778)
    { method: :sast_container_artifact, options: [Ci::Build::SAST_CONTAINER_FILE, 'sast:container'] },
    { method: :sast_container_artifact, options: [Ci::Build::SAST_CONTAINER_FILE, 'container_scanning'] },
    { method: :container_scanning_artifact, options: [Ci::Build::CONTAINER_SCANNING_FILE, 'sast:container'] },
    { method: :container_scanning_artifact, options: [Ci::Build::CONTAINER_SCANNING_FILE, 'container_scanning'] },
    { method: :dast_artifact, options: [Ci::Build::DAST_FILE, 'dast'] }
  ].freeze

  PIPELINE_ARTIFACTS_METHODS.each do |method_test|
    method, options = method_test.values_at(:method, :options)
    describe method.to_s do
      context 'has corresponding job' do
        let!(:build) do
          filename, name = options

          create(
            :ci_build,
            :artifacts,
            name: name,
            pipeline: pipeline,
            options: {
              artifacts: {
                paths: [filename]
              }
            }
          )
        end

        it { expect(pipeline.send(method)).to eq(build) }
      end

      context 'no codequality job' do
        before do
          create(:ci_build, pipeline: pipeline)
        end

        it { expect(pipeline.send(method)).to be_nil }
      end
    end
  end

  %w(sast dast performance sast_container container_scanning).each do |type|
    method = "has_#{type}_data?"

    describe "##{method}" do
      let(:artifact) { double(success?: true) }

      before do
        allow(pipeline).to receive(:"#{type}_artifact").and_return(artifact)
      end

      it { expect(pipeline.send(method.to_sym)).to be_truthy }
    end
  end

  %w(sast dast performance sast_container container_scanning).each do |type|
    method = "expose_#{type}_data?"

    describe "##{method}" do
      before do
        allow(pipeline).to receive(:"has_#{type}_data?").and_return(true)
        allow(pipeline.project).to receive(:feature_available?).and_return(true)
      end

      it { expect(pipeline.send(method.to_sym)).to be_truthy }
    end
  end
end
