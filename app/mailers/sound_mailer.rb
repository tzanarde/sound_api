# frozen_string_literal: true

class SoundMailer < ApplicationMailer
  def new_sound
    send_email
  end

  private

  def send_email
    mail to: @email, subject: @subject
  end
end
