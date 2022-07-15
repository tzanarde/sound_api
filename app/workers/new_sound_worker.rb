class NewSoundWorker
  def perform(sound)
    SoundMailer.new_sound.deliver_now
  end
end
