require 'rails_helper'

describe Deployable do
  describe '#create_deployment' do
    let(:deployment) { job.real_last_deployment }
    let(:environment) { deployment&.environment }

    context 'when the deployable object will deploy to production' do
      let(:job) { create(:ci_build, :start_review_app) }

      it 'creates a deployment and environment record' do
        expect(deployment.project).to eq(job.project)
        expect(deployment.ref).to eq(job.ref)
        expect(deployment.tag).to eq(job.tag)
        expect(deployment.sha).to eq(job.sha)
        expect(deployment.user).to eq(job.user)
        expect(deployment.deployable).to eq(job)
        expect(deployment.on_stop).to eq('stop_review_app')
        expect(environment.name).to eq('review/master')
      end
    end

    context 'when the deployable object will not deploy' do
      let(:job) { create(:ci_build) }

      it 'does not create a deployment and environment record' do
        expect(deployment).to be_nil
        expect(environment).to be_nil
      end
    end
  end
end
