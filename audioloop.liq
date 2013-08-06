#!/usr/bin/liquidsoap
#########################################
# bobina+streamer  1.5                  #
# NO(c) radioblackout.org               #
# One Station Against the Nation        #
#########################################

#set("log.file.path","/var/log/liquidsoap/bob.log")
#set("server.telnet",true)
#set("server.telnet.port",8001)
#set("server.telnet.bind_addr","192.168.10.0")
set("alsa.buffer_length",400)
#set("alsa.periods",10)
#set("buffering.kind","disk_manyfiles")
#set("decoding.buffer_length",50.)


# bobina: files e playlists

mp3_giorno = playlist("/home/bobina/global", mode="random")
mp3_spot = playlist("/home/bobina/spot", mode="random")
mp3_iniziative = playlist("/home/bobina/spot_iniziative", mode="random")
mp3_electronature = single("/home/electronature/latest/latest.mp3")
security = playlist.safe("/home/musica", mode="random")


# flusso principale

radio = mp3_giorno
radio = random( weights = [1,4,1], [delay(700.,mp3_spot), radio, delay(2700.,mp3_iniziative)])
#radio = random(weights = [1,2], [delay(1.,mp3_spot), radio])
radio = fallback( track_sensitive=false, [radio, security])
#radio = smart_crossfade(fade_out=2.0,fade_in=2.0,radio)
#radio = skip_blank(threshold=-50.,length=3.,radio)

# introduzioni varie
#studio=(audio_to_stereo((input.http("http://stream.radioblackout.org/studiomobile.ogg", buffer=9.0):source(audio=1))):source(audio=2))
studio=input.http("http://stream.radioblackout.org/studiomobile.ogg", buffer=9.0)
#full = fallback(track_sensitive=false, [input.http("http://192.168.10.245:8000/festa.ogg"), radio])
#full = fallback(track_sensitive=false, [input.http("http://stream.radioblackout.org/studiomobile.ogg"), radio])
full = fallback(track_sensitive=false, [studio, radio])
#electronature = at ({2w and 00h05}, mp3_electronatur
electronature = switch([({ 7w and 00h06 }, mp3_electronature)])
#buongiorno = switch([({ 1w and 8h00 }, mp3_buongiorno)])
#buongiorno = switch([({ 2w and 8h00 }, mp3_buongiorno)])
#buongiorno = switch([({ 3w and 8h00 }, mp3_buongiorno)])
#buongiorno = switch([({ 4w and 8h00 }, mp3_buongiorno)])
#buongiorno = switch([({ 5w and 8h00 }, mp3_buongiorno)])
#buongiorno = switch([({ 6w and 8h00 }, mp3_buongiorno)])
#buongiorno = switch([({ 7w and 8h00 }, mp3_buongiorno)])
#matinata = at ({7w and 11h00}, (mp3_matinata))
new_full = fallback(track_sensitive=false,[electronature, full])
#new_full = switch([({2w and 00h05}, mp3_electronature), (full)])
#new_full = normalize(new_full)


#out=(full)
#output.ao(mksafe(full))
#output.jack(server="bobina",mksafe(full))

#output.alsa(bufferize=true, new_full)
output.alsa(id="bobina",bufferize=true,device="hw:1", new_full)
#output.alsa(id="bobina",bufferize=true,device="hw:1", full)
