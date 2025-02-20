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
  const [currentScore, setCurrentScore] = useState({
    score: 0,
    accuracy: 0,
    message: "",
  });
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentSong, setCurrentSong] = useState<{
    code: string;
    title: string;
    artist: string;
    videoPath: string;
    firstLyric: string;
  } | null>(null);

  const [typedSong, setTypedSong] = useState<{
    code: string;
    title: string;
    artist: string;
  } | null>(null);

  const [songQueue, setSongQueue] = useState<
    {
      id: string;
      code: string;
      title: string;
      artist: string;
      videoPath: string;
      firstLyric: string;
    }[]
  >([]);
  const [showNoCreditsMessage, setShowNoCreditsMessage] = useState(false);

  const handleSongSubmit = async (code: string, addToQueue = false) => {
    if (credits < settings.credits.costPerSong) {
      setShowNoCreditsMessage(true);
      setTimeout(() => setShowNoCreditsMessage(false), 3000);
      return;
    }

    const song = await readSongFromDb(code);
    if (song) {
      setCredits((prev) => prev - settings.credits.costPerSong);

      if (addToQueue && currentSong) {
        setSongQueue((prev) => [
          ...prev,
          { ...song, id: Math.random().toString() },
        ]);
      } else if (currentSong) {
        setSongQueue((prev) => [
          { ...song, id: Math.random().toString() },
          ...prev,
        ]);
      } else {
        setCurrentSong(song);
        setIsPlaying(true);
      }

      // Score handling moved to VideoPlayer onEnded prop
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
    <div className="min-h-screen w-full bg-[#1a2942] relative overflow-hidden">
      <ParticleBackground />

      {/* Version and Credits */}
      <div className="absolute top-4 left-4 text-yellow-500 text-sm">v1.1</div>
      <div className="absolute top-4 right-4 flex items-center gap-2 bg-black/40 rounded-lg px-3 py-1">
        <div className="text-yellow-500">💰</div>
        <div className="text-yellow-500 text-xl font-bold">{credits}</div>
      </div>

      {/* Centered Numeric Input */}
      <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
        <NumericInput
          onSubmit={(code) => handleSongSubmit(code, false)}
          onChange={async (value) => {
            if (value.length === 5) {
              const song = await readSongFromDb(value);
              if (song) {
                setTypedSong({
                  code: song.code,
                  title: song.title,
                  artist: song.artist,
                });
              }
            } else {
              setTypedSong(null);
            }
          }}
        />
      </div>

      {/* Bottom Info Bar for Typed Song */}
      <div className="fixed bottom-0 left-0 right-0 bg-black py-3 grid grid-cols-3 text-white">
        <div className="border-r border-gray-800 px-4">
          <div className="text-gray-500 text-sm mb-1">CÓDIGO</div>
          <div className="text-xl">{typedSong ? typedSong.code : "1234"}</div>
        </div>
        <div className="border-r border-gray-800 px-4">
          <div className="text-gray-500 text-sm mb-1">CANTOR:</div>
          <div className="text-xl">
            {typedSong ? typedSong.artist : "Unknown Artist"}
          </div>
        </div>
        <div className="px-4">
          <div className="text-gray-500 text-sm mb-1">MUSICA:</div>
          <div className="text-xl">
            {typedSong ? typedSong.title : "Untitled Song"}
          </div>
        </div>
      </div>

      {/* Bottom Right Queue Input */}
      {currentSong && (
        <div className="fixed bottom-24 right-4 z-10">
          <NumericInput
            onSubmit={(code) => handleSongSubmit(code, true)}
            size="small"
            placeholder="Add to queue..."
          />
        </div>
      )}

      {/* Queue Display */}
      <QueueDisplay
        queue={songQueue.map((song) => ({
          id: song.id,
          code: song.code,
          title: song.title,
          artist: song.artist,
        }))}
        onRemoveItem={(id) => {
          setSongQueue((prev) => prev.filter((song) => song.id !== id));
          setCredits((prev) => prev + settings.credits.costPerSong);
        }}
      />

      {/* Info Bar at the bottom */}
      {currentSong && (
        <>
          <VideoPlayer
            videoUrl={currentSong.videoPath}
            isPlaying={isPlaying}
            onPlayPause={handlePlayPause}
            onEnded={() => {
              const score = Math.floor(Math.random() * 101);
              let message = "";

              if (score >= 90) {
                message = "Incrível! Você é uma estrela! 🌟";
              } else if (score >= 80) {
                message = "Fantástico! Você arrasou! 🎉";
              } else if (score >= 70) {
                message = "Muito bom! Continue assim! 🎵";
              } else if (score >= 60) {
                message = "Boa performance! 👏";
              } else {
                message = "Continue praticando! 💪";
              }

              setShowScore(true);
              setCurrentScore({
                score,
                accuracy: Math.floor(Math.random() * 20) + 80,
                message,
              });

              setTimeout(() => {
                setShowScore(false);
                if (songQueue.length > 0) {
                  const [nextSong, ...remainingQueue] = songQueue;
                  setCurrentSong(nextSong);
                  setSongQueue(remainingQueue);
                  setIsPlaying(true);
                } else {
                  setCurrentSong(null);
                  setIsPlaying(false);
                }
              }, 6000);
            }}
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
        message={currentScore.message}
      />
    </div>
  );
};

export default Home;
