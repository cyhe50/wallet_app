module Transaction::AasmState
  extend ActiveSupport::Concern

  included do
    include AASM
    enum aasm_state: { processing: 0, success: 1, failed: 2 }

    aasm :aasm_state, enum: true do
      state :processing
      state :success
      state :failed

      event :success do
        transitions from: :processing, to: :success
      end

      event :fail do
        transitions from: :processing, to: :failed
      end
    end
  end
end
