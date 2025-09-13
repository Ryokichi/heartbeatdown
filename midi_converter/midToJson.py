#https://en.wikipedia.org/wiki/General_MIDI#Program_change_events
import mido
import json


midiPath = 'midi_files/tori_no_uta.mid'
mid = mido.MidiFile(midiPath)

ticks_per_beat = mid.ticks_per_beat

music_data = {
    'tickes_per_beat': ticks_per_beat,
    'notes': {},
    'program_change': {},
    'set_tempo': [],
}

for i, track in enumerate(mid.tracks):
    for msg in track:
        if msg.type == "note_on":
            channel = msg.channel
            music_data['notes'].setdefault(channel, [])
            music_data['notes'][channel].append({
                    'note' : msg.note,
                    'velocity': msg.velocity,
                    'time': msg.time
            })
            pass
        elif msg.type == 'program_change': #Define o instrumento
            program = msg.program
            music_data['program_change'].setdefault(program, [])
            music_data['program_change'][program].append({
                'channel': msg.channel,
                'time': msg.time
            })
            pass
        elif msg.type == 'pitchwheel': #Define volume
            pass
        elif msg.type == 'control_change': 
            pass
        elif msg.type == 'end_of_track':
            pass
        elif msg.type == 'set_tempo':
            music_data['set_tempo'].append({
                'tempo': msg.tempo,
                'time': msg.time
            })
            pass
        elif msg.type == 'key_signature':
            pass
        elif msg.type == 'time_signature':
            pass
        elif msg.type == 'track_name':
            pass
        elif msg.type == 'midi_port':
            pass
        elif msg.type == 'sysex':
            pass
        elif msg.type == 'text':
            pass
        else:
            print(msg.type)


print (ticks_per_beat)

with open('conveted.txt', 'w', encoding='utf-8') as f:
    f.write(str(mid))

with open('music_notes.json', 'w', encoding='utf-8') as f:
    json.dump(music_data, f, ensure_ascii=False, indent=4)
