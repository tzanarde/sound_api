user = User.create!(email: 'example@example.com', password: 'password')
Sound.create!(name: 'clap-808', duration: '5', user_id: user.id, file_url: 'data/clap-808.wav')
Sound.create!(name: 'clap-analog', duration: '5', user_id: user.id, file_url: 'data/clap-analog.wav')
Sound.create!(name: 'clap-crushed', duration: '5', user_id: user.id, file_url: 'ata/clap-crushed.wav')