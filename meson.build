project('squeezelite', ['c', 'cpp'],
  version : files('project_version.txt'),
  meson_version : '>= 0.62.0',
  license : ['GPL-3.0-or-later'],
  # license_files : ['LICENSE.txt'],
  default_options : [
    'c_args=-fcommon',
    'cpp_args=-fcommon -Wno-multichar',
    'optimization=2',
    'warning_level=1',
  ],
)

project_version_components = meson.project_version().split('+')
project_version_build_metadata = []
foreach project_version_component_ix : range(1, project_version_components.length())
  project_version_component = project_version_components[project_version_component_ix]
  foreach project_version_build_metadata_identifier : project_version_component.split('.')
    if project_version_build_metadata_identifier == ''
      error('Project version build metadata identifiers MUST NOT be empty:', project_version_component)
    endif
  endforeach
  project_version_build_metadata += [project_version_component]
endforeach
project_version_build_metadata = '+'.join(project_version_build_metadata)
if project_version_components.length() > 2
  error('Project version build metadata MUST NOT contain plus signs:', project_version_build_metadata)
endif
project_version_components = project_version_components[0].split('-')
project_version_pre_release = []
foreach project_version_component_ix : range(1, project_version_components.length())
  project_version_pre_release += [project_version_components[project_version_component_ix]]
endforeach
project_version_pre_release = '-'.join(project_version_pre_release)
foreach project_version_pre_release_identifier : project_version_pre_release.split('.')
  if project_version_pre_release_identifier == ''
    error('Project pre-release version identifiers MUST NOT be empty:', project_version_pre_release)
  endif
endforeach
project_version_core = project_version_components[0]
project_version_components = project_version_core.split('.')
if project_version_components.length() != 3
  error('Project version core MUST consist of 3 dot separated identifiers:', project_core_version)
endif
project_version_major = project_version_components[0].to_int()
project_version_minor = project_version_components[1].to_int()
project_version_patch = project_version_components[2].to_int()

host_system = host_machine.system()
host_system_freebsd = host_system == 'freebsd'
host_system_linux = host_system == 'linux'
host_system_osx = host_system == 'darwin'
# TODO(bb010g): Standalone SUN pre-processor definition (separate from LINUX)
host_system_sun = host_system == 'sunos'
host_system_win = host_system == 'windows'

opt_auto_link_dlsym = get_option('auto_link_dlsym')

opt_codec_alac = get_option('codec_alac')
opt_codec_dsd = get_option('codec_dsd')
opt_codec_faad2 = get_option('codec_faad2')
opt_codec_ffmpeg = get_option('codec_ffmpeg')
opt_codec_flac = get_option('codec_flac')
opt_codec_mad = get_option('codec_mad')
opt_codec_mpg123 = get_option('codec_mpg123')
opt_codec_opus = get_option('codec_opus')
opt_codec_pcm = get_option('codec_pcm')
opt_codec_vorbis = get_option('codec_vorbis')
opt_control_infrared = get_option('control_infrared')
opt_executable_name_base = get_option('executable_name_base')
opt_executable_name_suffix = get_option('executable_name_suffix')
opt_gpio = get_option('gpio')
opt_link_dlsym_faad2 = get_option('link_dlsym_faad2')
opt_link_dlsym_flac = get_option('link_dlsym_flac')
opt_link_dlsym_libav = get_option('link_dlsym_libav')
opt_link_dlsym_lirc = get_option('link_dlsym_lirc')
opt_link_dlsym_mad = get_option('link_dlsym_mad')
opt_link_dlsym_mpg123 = get_option('link_dlsym_mpg123')
opt_link_dlsym_opus = get_option('link_dlsym_opus')
opt_link_dlsym_soxr = get_option('link_dlsym_soxr')
opt_link_dlsym_ssl = get_option('link_dlsym_ssl')
opt_link_dlsym_vorbis = get_option('link_dlsym_vorbis')
opt_model_name = get_option('model_name')
opt_output_alsa = get_option('output_alsa')
opt_output_portaudio = get_option('output_portaudio')
opt_output_pulseaudio = get_option('output_pulseaudio')
opt_output_stdout = get_option('output_stdout')
opt_output_visualizer_export = get_option('output_visualizer_export')
opt_raspberry_pi = get_option('raspberry_pi')
opt_sample_processing = get_option('sample_processing')
opt_sample_resampling = get_option('sample_resampling')
opt_sample_resampling_mp = get_option('sample_resampling_mp')
opt_ssl = get_option('ssl')
opt_system_event_eventfd = get_option('system_event_eventfd')
opt_system_event_selfpipe = get_option('system_event_selfpipe')
opt_system_event_winevent = get_option('system_event_winevent')

# TODO(Meson 1.1.0) Use `feature.enable_auto_if()` & `feature.disable_auto_if()`

# opt_link_dlsym_faad2 = opt_link_dlsym_faad2.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_flac = opt_link_dlsym_flac.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_libav = opt_link_dlsym_libav.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_lirc = opt_link_dlsym_lirc.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_mad = opt_link_dlsym_mad.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_mpg123 = opt_link_dlsym_mpg123.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_opus = opt_link_dlsym_opus.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_soxr = opt_link_dlsym_soxr.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_ssl = opt_link_dlsym_ssl.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())
# opt_link_dlsym_vorbis = opt_link_dlsym_vorbis.enable_auto_if(opt_auto_link_dlsym.enabled()).disable_auto_if(opt_auto_link_dlsym.disabled())

opt_link_dlsym_faad2 = opt_link_dlsym_faad2.auto() ? opt_auto_link_dlsym : opt_link_dlsym_faad2
opt_link_dlsym_flac = opt_link_dlsym_flac.auto() ? opt_auto_link_dlsym : opt_link_dlsym_flac
opt_link_dlsym_libav = opt_link_dlsym_libav.auto() ? opt_auto_link_dlsym : opt_link_dlsym_libav
opt_link_dlsym_lirc = opt_link_dlsym_lirc.auto() ? opt_auto_link_dlsym : opt_link_dlsym_lirc
opt_link_dlsym_mad = opt_link_dlsym_mad.auto() ? opt_auto_link_dlsym : opt_link_dlsym_mad
opt_link_dlsym_mpg123 = opt_link_dlsym_mpg123.auto() ? opt_auto_link_dlsym : opt_link_dlsym_mpg123
opt_link_dlsym_opus = opt_link_dlsym_opus.auto() ? opt_auto_link_dlsym : opt_link_dlsym_opus
opt_link_dlsym_soxr = opt_link_dlsym_soxr.auto() ? opt_auto_link_dlsym : opt_link_dlsym_soxr
opt_link_dlsym_ssl = opt_link_dlsym_ssl.auto() ? opt_auto_link_dlsym : opt_link_dlsym_ssl
opt_link_dlsym_vorbis = opt_link_dlsym_vorbis.auto() ? opt_auto_link_dlsym : opt_link_dlsym_vorbis

opt_sample_resampling_mp = opt_sample_resampling_mp.require(opt_sample_resampling.enabled())
opt_sample_resampling = opt_sample_resampling.require(opt_sample_processing.enabled())

# TODO(Meson 1.1.0) Use `feature.enable_auto_if()` & `feature.disable_auto_if()`
# opt_output_portaudio = opt_output_portaudio.enable_auto_if(
#   host_system_freebsd or
#   host_system_osx or
#   host_system_sun or
#   host_system_win
# )
optauto_output_portaudio = (
  host_system_freebsd or
  host_system_osx or
  host_system_sun or
  host_system_win
)

# TODO(Meson 1.1.0) Use `feature.enable_auto_if()` & `feature.disable_auto_if()`
# opt_output_alsa = opt_output_alsa.enable_auto_if(host_system_linux and not (
#   opt_output_portaudio.enabled() or
#   opt_output_pulseaudio.enabled()
# ))
optauto_output_alsa = host_system_linux and not (
  (opt_output_portaudio.auto() ? optauto_output_portaudio : opt_output_portaudio.enabled()) or
  opt_output_pulseaudio.enabled()
)

squeezelite_conf_data = configuration_data()
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_ALAC', opt_codec_alac.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_DSD', opt_codec_dsd.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_FAAD2', opt_codec_faad2.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_FFMPEG', opt_codec_ffmpeg.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_FLAC', opt_codec_flac.allowed(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_MAD', opt_codec_mad.allowed(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_MPG123', opt_codec_mpg123.allowed(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_OPUS', opt_codec_opus.enabled(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_PCM', opt_codec_pcm.allowed(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CODEC_VORBIS', opt_codec_vorbis.allowed(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_CONTROL_INFRARED', opt_control_infrared.enabled(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_GPIO', opt_gpio.enabled(), description: '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_FAAD2', opt_link_dlsym_faad2.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_FLAC', opt_link_dlsym_flac.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_LIBAV', opt_link_dlsym_libav.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_LIRC', opt_link_dlsym_lirc.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_MAD', opt_link_dlsym_mad.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_MPG123', opt_link_dlsym_mpg123.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_OPUS', opt_link_dlsym_opus.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_SOXR', opt_link_dlsym_soxr.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_SSL', opt_link_dlsym_ssl.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_LINK_DLSYM_VORBIS', opt_link_dlsym_vorbis.allowed(), description : '')
squeezelite_conf_data.set_quoted('SQUEEZELITE_OPT_MODEL_NAME', opt_model_name, description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_OUTPUT_ALSA', opt_output_alsa.auto() ? optauto_output_alsa : opt_output_alsa.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_OUTPUT_PORTAUDIO', opt_output_portaudio.auto() ? optauto_output_portaudio : opt_output_portaudio.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_OUTPUT_PULSEAUDIO', opt_output_pulseaudio.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_OUTPUT_STDOUT', opt_output_stdout.allowed(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_OUTPUT_VISUALIZER_EXPORT', opt_output_visualizer_export.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_RASPBERRY_PI', opt_raspberry_pi.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_SAMPLE_PROCESSING', opt_sample_processing.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_SAMPLE_RESAMPLING', opt_sample_resampling.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_SAMPLE_RESAMPLING_MP', opt_sample_resampling_mp.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_SSL', opt_ssl.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_SYSTEM_EVENT_EVENTFD', opt_system_event_eventfd.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_SYSTEM_EVENT_SELFPIPE', opt_system_event_selfpipe.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_OPT_SYSTEM_EVENT_WINEVENT', opt_system_event_winevent.enabled(), description : '')
squeezelite_conf_data.set10('SQUEEZELITE_SYSTEM_FREEBSD', host_system_freebsd)
squeezelite_conf_data.set10('SQUEEZELITE_SYSTEM_LINUX', host_system_linux)
squeezelite_conf_data.set10('SQUEEZELITE_SYSTEM_OSX', host_system_osx)
squeezelite_conf_data.set10('SQUEEZELITE_SYSTEM_SUN', host_system_sun)
squeezelite_conf_data.set10('SQUEEZELITE_SYSTEM_WIN', host_system_win)
squeezelite_conf_data.set_quoted('SQUEEZELITE_VERSION_BUILD_METADATA', project_version_build_metadata)
squeezelite_conf_data.set('SQUEEZELITE_VERSION_MAJOR', project_version_major)
squeezelite_conf_data.set('SQUEEZELITE_VERSION_MINOR', project_version_minor)
squeezelite_conf_data.set('SQUEEZELITE_VERSION_PATCH', project_version_patch)
squeezelite_conf_data.set_quoted('SQUEEZELITE_VERSION_PRE_RELEASE', project_version_pre_release)

squeezelite_conf_file = configure_file(configuration : squeezelite_conf_data,
  output : 'squeezelite_config.h',
)

squeezelite_exe_name = opt_executable_name_base
squeezelite_exe_name_suffix = opt_executable_name_suffix

squeezelite_exe_src = files(
  'buffer.c',
  'decode.c',
  # 'flac.c', # codec: FLAC
  'main.c',
  'output.c',
  # 'output_alsa.c', # output: ALSA
  # 'output_pa.c', # output: PortAudio
  'output_pack.c',
  # 'output_pulse.c', # output: PulseAudio
  # 'output_stdout.c', # output: standard output
  # 'pcm.c', # codec: PCM
  'slimproto.c',
  'slimproto.h',
  'squeezelite.h',
  'stream.c',
  'utils.c',
  # 'vorbis.c', # codec: Vorbis
) + [
  squeezelite_conf_file,
]

squeezelite_exe_deps = []
squeezelite_exe_dlsym_deps = []

# https://github.com/mikebrady/alac
alac_dep = dependency('alac', required : opt_codec_alac.enabled())
if opt_codec_alac.enabled()
  squeezelite_exe_deps += [alac_dep]
  squeezelite_exe_src += files(
    'alac.c',
    'alac_wrapper.cpp',
    'alac_wrapper.h',
  )
endif

dsd2pcm_dep = declare_dependency(
  sources : files(
    'dsd2pcm/dsd2pcm.c',
    'dsd2pcm/dsd2pcm.h',
  ),
)
if opt_codec_dsd.enabled()
  squeezelite_exe_deps += [dsd2pcm_dep]
  squeezelite_exe_src += files(
    'dop.c',
    'dsd.c',
  )
endif

faad2_dep = dependency('faad2', required : opt_codec_faad2.allowed())
if opt_codec_faad2.allowed()
  if opt_link_dlsym_faad2.allowed()
    squeezelite_exe_dlsym_deps += [faad2_dep]
  else
    squeezelite_exe_deps += [faad2_dep]
  endif
  squeezelite_exe_src += files(
    'faad.c',
  )
endif

libavcodec_dep = dependency('libavcodec', required : opt_codec_ffmpeg.enabled())
libavformat_dep = dependency('libavformat', required : opt_codec_ffmpeg.enabled())
libavutil_dep = dependency('libavutil', required : opt_codec_ffmpeg.enabled())
if opt_codec_ffmpeg.enabled()
  if opt_link_dlsym_libav.allowed()
    squeezelite_exe_dlsym_deps += [libavcodec_dep, libavformat_dep, libavutil_dep]
  else
    squeezelite_exe_deps += [libavcodec_dep, libavformat_dep, libavutil_dep]
  endif
  squeezelite_exe_src += files(
    'ffmpeg.c',
  )
endif

flac_dep = dependency('flac', required : opt_codec_flac.allowed())
if opt_codec_flac.allowed()
  if opt_link_dlsym_flac.allowed()
    squeezelite_exe_dlsym_deps += [flac_dep]
  else
    squeezelite_exe_deps += [flac_dep]
  endif
  squeezelite_exe_src += files(
    'flac.c',
  )
endif

mad_dep = dependency('mad', required : opt_codec_mad.allowed())
if opt_codec_mad.allowed()
  if opt_link_dlsym_mad.allowed()
    squeezelite_exe_dlsym_deps += [mad_dep]
  else
    squeezelite_exe_deps += [mad_dep]
  endif
  squeezelite_exe_src += files(
    'mad.c',
  )
endif

mpg123_dep = dependency('libmpg123', required : opt_codec_mpg123.allowed())
if opt_codec_mpg123.allowed()
  if opt_link_dlsym_mpg123.allowed()
    squeezelite_exe_dlsym_deps += [mpg123_dep]
  else
    squeezelite_exe_deps += [mpg123_dep]
  endif
  squeezelite_exe_src += files(
    'mpg.c',
  )
endif

opus_dep = dependency('opus', required : opt_codec_opus.enabled())
if opt_codec_opus.enabled()
  if opt_link_dlsym_opus.allowed()
    squeezelite_exe_dlsym_deps += [opus_dep]
  else
    squeezelite_exe_deps += [opus_dep]
  endif
  squeezelite_exe_src += files(
    'opus.c',
  )
endif

if opt_codec_pcm.allowed()
  squeezelite_exe_src += files(
    'pcm.c',
  )
endif

vorbisfile_dep = dependency('vorbisfile', required : opt_codec_vorbis.allowed())
# TODO(Dusk): figure out TREMOR_ONLY & dynamically linking Tremor
# vorbisidec_dep = dependency('vorbisidec', required : opt_codec_vorbis.allowed())
if opt_codec_vorbis.allowed()
  if opt_link_dlsym_vorbis.allowed()
    # squeezelite_exe_dlsym_deps += [vorbisfile_dep, vorbisidec_dep]
    squeezelite_exe_dlsym_deps += [vorbisfile_dep]
  else
    # squeezelite_exe_deps += [vorbisfile_dep, vorbisidec_dep]
    squeezelite_exe_deps += [vorbisfile_dep]
  endif
  squeezelite_exe_src += files(
    'vorbis.c',
  )
endif

lirc_dep = dependency('lirc', required : opt_control_infrared.enabled())
if opt_control_infrared.enabled()
  if opt_link_dlsym_lirc.allowed()
    squeezelite_exe_dlsym_deps += [lirc_dep]
  else
    squeezelite_exe_deps += [lirc_dep]
  endif
  squeezelite_exe_src += files(
    'ir.c',
  )
endif

if opt_gpio.enabled()
  squeezelite_exe_src += files(
    'gpio.c',
  )
endif

alsa_dep = dependency('alsa', required : opt_output_alsa.auto() ? optauto_output_alsa : opt_output_alsa.enabled())
if opt_output_alsa.auto() ? optauto_output_alsa : opt_output_alsa.enabled()
  squeezelite_exe_deps += [alsa_dep]
  squeezelite_exe_src += files(
    'output_alsa.c',
  )
endif

portaudio_dep = dependency('portaudio', required : opt_output_portaudio.auto() ? optauto_output_portaudio : opt_output_portaudio.enabled())
if opt_output_portaudio.auto() ? optauto_output_portaudio : opt_output_portaudio.enabled()
  squeezelite_exe_deps += [portaudio_dep]
  squeezelite_exe_src += files(
    'output_pa.c',
  )
  if squeezelite_exe_name_suffix[-1] == '-'
    squeezelite_exe_name_suffix += 'pa-'
  elif squeezelite_exe_name_suffix[1] == '-'
    squeezelite_exe_name_suffix = '-pa' + squeezelite_exe_name_suffix
  endif
endif

pulseaudio_dep = dependency('pulseaudio', required : opt_output_pulseaudio.enabled())
if opt_output_pulseaudio.enabled()
  squeezelite_exe_deps += [pulseaudio_dep]
  squeezelite_exe_src += files(
    'output_pulse.c',
  )
  if squeezelite_exe_name_suffix[-1] == '-'
    squeezelite_exe_name_suffix += 'pulse-'
  elif squeezelite_exe_name_suffix[1] == '-'
    squeezelite_exe_name_suffix = '-pulse' + squeezelite_exe_name_suffix
  endif
endif

if opt_output_stdout.allowed()
  squeezelite_exe_src += files(
    'output_stdout.c',
  )
endif

if opt_output_visualizer_export.enabled()
  squeezelite_exe_src += files(
    'output_vis.c',
  )
endif

if opt_raspberry_pi.enabled()
  squeezelite_exe_src += files(
    'minimal_gpio.c',
  )
endif

if opt_sample_processing.enabled()
  squeezelite_exe_src += files(
    'process.c',
  )
endif

soxr_dep = dependency('soxr', required : opt_sample_resampling.enabled())
if opt_sample_resampling.enabled()
  if opt_link_dlsym_soxr.allowed()
    squeezelite_exe_dlsym_deps += [soxr_dep]
  else
    squeezelite_exe_deps += [soxr_dep]
  endif
  squeezelite_exe_src += files(
    'resample.c',
  )
endif

crypto_dep = dependency('libcrypto', required : opt_ssl.enabled())
ssl_dep = dependency('libssl', required : opt_ssl.enabled())
if opt_ssl.enabled()
  if opt_link_dlsym_ssl.allowed()
    squeezelite_exe_dlsym_deps += [crypto_dep, ssl_dep]
  else
    squeezelite_exe_deps += [crypto_dep, ssl_dep]
  endif
  squeezelite_exe_src += files(
    'sslsym.c',
  )
endif

dl_dep = dependency('dl', required : squeezelite_exe_dlsym_deps != [])
if squeezelite_exe_dlsym_deps != []
  squeezelite_exe_deps += [dl_dep]
endif

foreach squeezelite_exe_dlsym_dep : squeezelite_exe_dlsym_deps
  squeezelite_exe_dep = squeezelite_exe_dlsym_dep.partial_dependency(
    compile_args : true,
    includes : true,
    sources : true,
  )
  squeezelite_exe_deps += [squeezelite_exe_dep]
endforeach

squeezelite_exe = executable(squeezelite_exe_name,
  build_by_default : true,
  dependencies : squeezelite_exe_deps,
  sources : squeezelite_exe_src,
  win_subsystem : 'console',
)
