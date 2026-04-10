import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _secondsRemaining = 1500;
  int _totalSeconds = 1500;
  bool _isRunning = false;
  String _currentMode = "Focus";

  int _sessionsCompleted = 0;
  int _totalMinutes = 0;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          _onTimerComplete();
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _onTimerComplete() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (_currentMode == "Focus") {
        _sessionsCompleted++;
        _totalMinutes += (_totalSeconds ~/ 60);
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _setMode(_currentMode);
    });
  }

  void _setMode(String mode) {
    _timer?.cancel();
    setState(() {
      _currentMode = mode;
      _isRunning = false;
      if (mode == "Focus") {
        _secondsRemaining = 1500;
      } else if (mode == "Short Break") {
        _secondsRemaining = 300;
      } else {
        _secondsRemaining = 900;
      }
      _totalSeconds = _secondsRemaining;
    });
  }

  String _formatTime(int s) {
    return "${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleTheme = Color(0xFF9181CB);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: const BoxDecoration(
              color: purpleTheme,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
                    const Text("Pomodoro Timer", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(_sessionsCompleted.toString(), "Sessions"),
                    _buildStatCard(_totalMinutes.toString(), "Minutes"),
                    _buildStatCard("1", "Until Break"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // TABS (Mode Switcher)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _modeButton("Focus"),
                _modeButton("Short Break"),
                _modeButton("Long Break"),
              ],
            ),
          ),

          // MAIN TIMER CARD
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(25, 15, 25, 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: SingleChildScrollView( // Prevents overflow on smaller screens
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text("$_currentMode Time", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    Text(_formatTime(_secondsRemaining), style: const TextStyle(fontSize: 65, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 20),

                    // Progress Ring
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: _secondsRemaining / _totalSeconds,
                            strokeWidth: 6,
                            color: purpleTheme,
                            backgroundColor: Colors.grey.shade100,
                          ),
                        ),
                        const Column(
                          children: [
                            Icon(Icons.access_time_filled, color: Colors.grey, size: 35),
                            Text("Keep Pushing", style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // THE BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _toggleTimer,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(color: purpleTheme, shape: BoxShape.circle),
                            child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 35),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: _resetTimer,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                            child: const Icon(Icons.refresh, color: Colors.black54, size: 25),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(String mode) {
    bool isActive = _currentMode == mode;
    return GestureDetector(
      onTap: () => _setMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF9181CB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.transparent : Colors.grey.shade200),
        ),
        child: Text(mode, style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
