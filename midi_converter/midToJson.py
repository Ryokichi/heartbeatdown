import mido
import json


midiPath = 'midi_files/digimon.mid'
mid = mido.MidiFile(midiPath)

ticks_per_beat = mid.ticks_per_beat

music_data = {
    'notes': {},
    'set_tempo': {}
}

for i, track in enumerate(mid.tracks):
    for msg in track:
        if msg.type == "note_on":
            channel = msg.channel
            music_data['notes'].setdefault(channel, [])
            music_data['notes'][channel].append({
                    'note' : msg.note,
                    'velocity': msg.velocity,
                    "time": msg.time
            })
            pass
        elif msg.type == 'pitchwheel':
            pass
        elif msg.type == 'control_change':
            pass
        elif msg.type == 'program_change':
            pass
        elif msg.type == 'end_of_track':
            pass
        elif msg.type == 'set_tempo':
            pass
        elif msg.type == 'key_signature':
            pass
        elif msg.type == 'time_signature':
            pass
        else:
            print(msg.type)


print(music_data)
print (ticks_per_beat)

with open('conveted.txt', 'w', encoding='utf-8') as f:
    f.write(str(mid))

with open('data.txt', 'w', encoding='utf-8') as f:
    f.write(str(music_data))
