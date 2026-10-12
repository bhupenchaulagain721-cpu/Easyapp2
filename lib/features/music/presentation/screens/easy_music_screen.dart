import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/company_footer.dart';

/// Music track model for Easy App Music & Radio player
class MusicTrack {
  final String id;
  final String title;
  final String artist;
  final String streamUrl;
  final String category;
  final Duration duration;

  const MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.streamUrl,
    required this.category,
    required this.duration,
  });
}

/// Sample curated playlist of Nepali music and Republic Nepal radio
final List<MusicTrack> nepaliTracks = [
  const MusicTrack(
    id: 'tr_1',
    title: 'Republic Nepal Live Audio Broadcast',
    artist: 'Republic Nepal TV & Radio Network',
    streamUrl: 'https://stream.republicnepal.tv/live_audio.mp3',
    category: 'Live FM Radio',
    duration: Duration(minutes: 0), // live
  ),
  const MusicTrack(
    id: 'tr_2',
    title: 'Resham Firiri (रेशम फिरिरी)',
    artist: 'Himalayan Folk Ensemble',
    streamUrl: 'https://assets.mixkit.co/music/preview/mixkit-himalayan-breeze-112.mp3',
    category: 'Nepali Folk & Acoustic',
    duration: Duration(minutes: 4, seconds: 12),
  ),
  const MusicTrack(
    id: 'tr_3',
    title: 'Maya Pirati (माया पिरती)',
    artist: 'Aarav Sharma & Priya KC',
    streamUrl: 'https://assets.mixkit.co/music/preview/mixkit-valley-sunset-245.mp3',
    category: 'Modern Adhunik Hit',
    duration: Duration(minutes: 3, seconds: 48),
  ),
  const MusicTrack(
    id: 'tr_4',
    title: 'Sirphul Siraima (शिरफूल शिरैमा)',
    artist: 'Gandaki Lok Dohori Pariwar',
    streamUrl: 'https://assets.mixkit.co/music/preview/mixkit-nepal-mountain-air-320.mp3',
    category: 'Lok Dohori',
    duration: Duration(minutes: 5, seconds: 02),
  ),
];

/// Easy Music & FM Radio Player Screen
class EasyMusicScreen extends ConsumerStatefulWidget {
  const EasyMusicScreen({super.key});

  @override
  ConsumerState<EasyMusicScreen> createState() => _EasyMusicScreenState();
}

class _EasyMusicScreenState extends ConsumerState<EasyMusicScreen> {
  Timer? _playbackTimer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 4, seconds: 12);

  @override
  void initState() {
    super.initState();
    _loadTrack(_currentIndex);
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_position < _duration) {
          _position += const Duration(seconds: 1);
        } else {
          _nextTrack();
        }
      });
    });
  }

  void _pauseTimer() {
    _playbackTimer?.cancel();
  }

  void _loadTrack(int index) {
    final track = nepaliTracks[index];
    setState(() {
      _currentIndex = index;
      _position = Duration.zero;
      _duration = track.duration == Duration.zero ? const Duration(minutes: 60) : track.duration;
    });
    if (_isPlaying) {
      _startTimer();
    }
  }

  void _playPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _startTimer();
    } else {
      _pauseTimer();
    }
  }

  void _nextTrack() {
    final next = (_currentIndex + 1) % nepaliTracks.length;
    _loadTrack(next);
  }

  void _prevTrack() {
    final prev = (_currentIndex - 1 + nepaliTracks.length) % nepaliTracks.length;
    _loadTrack(prev);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final current = nepaliTracks[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Easy Music & Radio (कोड म्युजिक)',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Album Cover Visualizer
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF165B5E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _isPlaying ? Icons.music_note_rounded : Icons.radio_rounded,
                          size: 80,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title & Artist
                    Text(
                      current.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      current.artist,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        current.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Seek Slider
                    Slider(
                      value: _position.inSeconds.toDouble().clamp(
                            0.0,
                            (_duration.inSeconds > 0 ? _duration.inSeconds : 100).toDouble(),
                          ),
                      max: (_duration.inSeconds > 0 ? _duration.inSeconds : 100).toDouble(),
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.black12,
                      onChanged: (val) {
                        setState(() {
                          _position = Duration(seconds: val.toInt());
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          Text(
                            _duration.inSeconds > 0 ? _formatDuration(_duration) : 'LIVE',
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _prevTrack,
                          icon: const Icon(Icons.skip_previous_rounded, size: 36),
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: _playPause,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _nextTrack,
                          icon: const Icon(Icons.skip_next_rounded, size: 36),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Playlist List
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'प्लेलिस्ट (Curated Playlist):',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: nepaliTracks.length,
                      itemBuilder: (context, i) {
                        final t = nepaliTracks[i];
                        final isSelected = i == _currentIndex;
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _currentIndex = i;
                            });
                            _loadTrack(i);
                          },
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isSelected ? Icons.graphic_eq_rounded : Icons.music_note,
                              color: isSelected ? Colors.white : Colors.black54,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            t.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.primary : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            '${t.artist} · ${t.category}',
                            style: const TextStyle(fontSize: 10),
                          ),
                          trailing: isSelected && _isPlaying
                              ? const Icon(Icons.volume_up, size: 16, color: AppColors.primary)
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const CompanyFooter(),
          ],
        ),
      ),
    );
  }
}
