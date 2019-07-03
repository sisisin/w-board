class EditorSummary < ApplicationRecord
  belongs_to :editor

  def name
    editor.name
  end
end
