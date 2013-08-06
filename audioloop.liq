#!/usr/bin/liquidsoap
#########################################
# audioloop+streamer  1.5                  #
#########################################

#set("log.file.path","/var/log/liquidsoap/bob.log")
#set("server.telnet",true)
#set("server.telnet.port",8001)
#set("server.telnet.bind_addr","192.168.10.0")
set("alsa.buffer_length",400)
#set("alsa.periods",10)
#set("buffering.kind","disk_manyfiles")
#set("decoding.buffer_length",50.)


# audioloop: files e playlists

mp3_giorno = playlist("/home/audioloop/global", mode="random")
mp3_spot = playlist("/home/audioloop/spot", mode="random")
mp3_talk2 = playlist("/home/audioloop/spot_talk2", mode="random")
mp3_talk1 = single("/home/talk1/latest/latest.mp3")
security = playlist.safe("/home/musica", mode="random")


# flusso principale

radio = mp3_giorno
radio = random( weights = [1,4,1], [delay(700.,mp3_spot), radio, delay(2700.,mp3_talk2)])
#radio = random(weights = [1,2], [delay(1.,mp3_spot), radio])
radio = fallback( track_sensitive=false, [radio, security])
#radio = smart_crossfade(fade_out=2.0,fade_in=2.0,radio)
#radio = skip_blank(threshold=-50.,length=3.,radio)

# introduzioni varie
#studio=(audio_to_stereo((input.http("http://localhost/live1.ogg", buffer=9.0):source(audio=1))):source(audio=2))
studio=input.http("http://localhost/live1.ogg", buffer=9.0)
#full = fallback(track_sensitive=false, [input.http("http://localhost:8000/live2.ogg"), radio])
#full = fallback(track_sensitive=false, [input.http("http://localhost/live1.ogg"), radio])
full = fallback(track_sensitive=false, [studio, radio])
#talk1 = at ({2w and 00h05}, mp3_talk1
talk1 = switch([({ 7w and 00h06 }, mp3_talk1)])
#wakeup = switch([({ 1w and 8h00 }, mp3_wakeup)])
#wakeup = switch([({ 2w and 8h00 }, mp3_wakeup)])
#wakeup = switch([({ 3w and 8h00 }, mp3_wakeup)])
#wakeup = switch([({ 4w and 8h00 }, mp3_wakeup)])
#wakeup = switch([({ 5w and 8h00 }, mp3_wakeup)])
#wakeup = switch([({ 6w and 8h00 }, mp3_wakeup)])
#wakeup = switch([({ 7w and 8h00 }, mp3_wakeup)])
#show3 = at ({7w and 11h00}, (mp3_show3))
new_full = fallback(track_sensitive=false,[talk1, full])
#new_full = switch([({2w and 00h05}, mp3_talk1), (full)])
#new_full = normalize(new_full)


#out=(full)
#output.ao(mksafe(full))
#output.jack(server="audioloop",mksafe(full))

#output.alsa(bufferize=true, new_full)
output.alsa(id="audioloop",bufferize=true,device="hw:1", new_full)
#output.alsa(id="audioloop",bufferize=true,device="hw:1", full)
