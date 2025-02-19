import React, { useState, useEffect } from "react";
import { motion } from "framer-motion";
import NumericInput from "./karaoke/NumericInput";
import InfoBar from "./karaoke/InfoBar";
import VideoPlayer from "./karaoke/VideoPlayer";
import QueueDisplay from "./karaoke/QueueDisplay";
import ParticleBackground from "./karaoke/ParticleBackground";
import SettingsMenu from "./karaoke/SettingsMenu";
import ScoreDisplay from "./karaoke/ScoreDisplay";
import { Alert, AlertTitle, AlertDescription } from "@/components/ui/alert";
import { readSongFromDb } from "@/lib/songDatabase";

const Home = () => {
  const [credits, setCredits] = useState(0);
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [settings, setSettings] = useState({
    credits: {
      value: 1,
      costPerSong: 1,
      autoDeduct: true,
    },
    playback: {
      defaultVolume: 75,
      autoplay: true,
      videoQuality: "high" as const,
      showNotes: true,
    },
    storage: {
      useExternalUSB: false,
      dbPath: "C:\\KaraokeDB",
      customBackground: "",
    },
  });
  const [showScore, setShowScore] = useState(false);
  const [currentScore, setCurrentScore] = useState({ score: 0, accuracy: 0 });
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentSong, setCurrentSong] = useState<{
    code: string;
    title: string;
    artist: string;
    videoPath: string;
    firstLyric: string;
  } | null>(null);
  const [showNoCreditsMessage, setShowNoCreditsMessage] = useState(false);

  const handleSongSubmit = async (code: string) => {
    if (credits < settings.credits.costPerSong) {
      setShowNoCreditsMessage(true);
      setTimeout(() => setShowNoCreditsMessage(false), 3000);
      return;
    }

    const song = await readSongFromDb(code);
    if (song) {
      setCurrentSong(song);
      setCredits((prev) => prev - settings.credits.costPerSong);
      setIsPlaying(true);

      // Simulate song ending after 10 seconds (in real app, this would be triggered by video end)
      const videoElement = document.querySelector("video");
      if (videoElement) {
        videoElement.onended = () => {
          setShowScore(true);
          setCurrentScore({
            score: Math.floor(Math.random() * 30) + 70,
            accuracy: Math.floor(Math.random() * 20) + 80,
          });
          setTimeout(() => {
            setShowScore(false);
            setCurrentSong(null);
            setIsPlaying(false);
          }, 6000);
        };
      }
    }
  };

  useEffect(() => {
    const handleKeyPress = (event: KeyboardEvent) => {
      if (event.key.toLowerCase() === "c") {
        setCredits((prev) => prev + settings.credits.value);
      } else if (event.key.toLowerCase() === "f") {
        setSettingsOpen(true);
      }
    };

    window.addEventListener("keydown", handleKeyPress);
    return () => window.removeEventListener("keydown", handleKeyPress);
  }, [settings.credits.value]);

  const handlePlayPause = () => {
    setIsPlaying(!isPlaying);
  };

  return (
    <div className="min-h-screen w-full bg-black relative overflow-hidden">
      <ParticleBackground />

      {/* Version and Credits */}
      <div className="absolute top-4 left-4 text-yellow-500 text-sm">v3.0</div>
      <div className="absolute top-4 right-4 flex items-center gap-2">
        <div className="text-yellow-500">💰</div>
        <div className="text-yellow-500 text-xl font-bold">{credits}</div>
      </div>

      {/* Centered Numeric Input */}
      <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
        <NumericInput onSubmit={handleSongSubmit} />
      </div>

      {/* Info Bar at the bottom */}
      {currentSong && (
        <>
          <VideoPlayer
            videoUrl={currentSong.videoPath}
            isPlaying={isPlaying}
            onPlayPause={handlePlayPause}
          />
          <InfoBar
            songCode={currentSong.code}
            artist={currentSong.artist}
            title={currentSong.title}
            firstLyric={currentSong.firstLyric}
          />
        </>
      )}

      {/* No Credits Message */}
      {showNoCreditsMessage && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -20 }}
          className="fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 z-50"
        >
          <Alert className="bg-red-500/90 border-red-600 text-white w-96">
            <AlertTitle className="text-lg font-bold">
              Insufficient Credits
            </AlertTitle>
            <AlertDescription>
              Please add credits to play songs (Press 'C' to add credits)
            </AlertDescription>
          </Alert>
        </motion.div>
      )}

      {/* Settings Menu */}
      <SettingsMenu
        open={settingsOpen}
        onOpenChange={setSettingsOpen}
        settings={settings}
        onSettingsChange={(key, value) => {
          const keys = key.split(".");
          setSettings((prev) => {
            const newSettings = { ...prev };
            let current = newSettings;
            for (let i = 0; i < keys.length - 1; i++) {
              current = current[keys[i]];
            }
            current[keys[keys.length - 1]] = value;
            return newSettings;
          });
        }}
      />

      <ScoreDisplay
        open={showScore}
        onOpenChange={setShowScore}
        score={currentScore.score}
        accuracy={currentScore.accuracy}
      />
    </div>
  );
};

export default Home;
