#https://en.wikipedia.org/wiki/General_MIDI#Program_change_events
import mido
import json
import time



def save_as_string(data, file_path):
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(str(data))
    pass

def save_as_json(data, file_path):
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    pass

def get_music_data(mid):
    music_data = {
        'ticks_per_beat': mid.ticks_per_beat,
        'notes': {},
        'program_change': {},
        'set_tempo': [],
    }

    track_time = 0

    for i, track in enumerate(mid.tracks):
        track_time = 0
        for msg in track:
            track_time += msg.time
            if msg.type == "note_on":
                channel = msg.channel
                music_data['notes'].setdefault(channel, [])
                music_data['notes'][channel].append({
                        'note' : msg.note,
                        'velocity': msg.velocity,
                        'time': msg.time,
                        'total_time': track_time
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

    return music_data

def get_time_in_secs(ticks, tpb, tempo):
    return ((ticks*tempo) / (1_000_000 * tpb) )

# # Função para calcular tempo_ms
def apply_tempo_to_notes(notes, tempos, ticks_per_beat):
    for channel, note_list in notes.items():
        # note_list.sort(key=lambda x: x['time'])  # garantir ordem
        aux_tempos = tempos
        aux_tempo2 = None
        aux_tempo_time = 0
        tempo_ticks = 0
        note_ticks = 0
        current_tempo = 500000
        ler_proximo_tempo = True

        for note in note_list:
            if (len(aux_tempos) > 0 and tempo_ticks <= note_ticks):
                aux_tempo2 = aux_tempos.pop(0)
                ler_proximo_tempo = False
            
            if (tempo_ticks <= note_ticks and ler_proximo_tempo == False):
                ler_proximo_tempo = True
                note_ticks = 0
                current_tempo = aux_tempo2['tempo']
                tempo_ticks = aux_tempo2['time']
                print("---", aux_tempo2)
                print("---Novo tempo:", current_tempo, " próximo troca em ", tempo_ticks)

            note['time_sec'] = mido.tick2second(note['total_time'], ticks_per_beat, current_tempo)
            note['test_sec'] = get_time_in_secs(note['total_time'], ticks_per_beat, current_tempo)
            note['tempo'] = current_tempo
            note_ticks += note['time']
            print (note_ticks, " | ", note)
            # input()

    return notes

# # Itera o arquivo levando em conta o tempo
# # Talvez seja opção se colocar um timer
# tempo_acumulado = 0
def get_music_data_using_play(mid):
    music_data = {
        'ticks_per_beat': mid.ticks_per_beat,
        'notes': {},
        'program_change': {},
        'set_tempo': [],
    }
    
    start_time = time.time()
    for msg in mid.play():
        elapsed_time = (time.time() - start_time)
        if msg.type == "note_on":
            print(elapsed_time, " -- ", msg)
            channel = msg.channel
            music_data['notes'].setdefault(channel, [])
            music_data['notes'][channel].append({
                    'note' : msg.note,
                    'velocity': msg.velocity,
                    'time': msg.time,
                    'elapsed': elapsed_time
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
    
    return music_data


midiPath = 'midi_files/tori_no_uta.mid'
mid = mido.MidiFile(midiPath)

print(mid.length)
save_as_string(mid, 'midFileConveted.txt')


# ---- Preparação ----
#music_data = get_music_data(mid)
music_data = get_music_data_using_play(mid)
# ticks_per_beat = music_data['ticks_per_beat']
# tempos = music_data['set_tempo']

#music_data['notes'] = apply_tempo_to_notes(music_data['notes'], tempos, ticks_per_beat)


save_as_json(music_data, 'music_data_ready.json')
