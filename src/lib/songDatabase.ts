import { parseIniContent, type SongEntry } from "./iniParser";

interface Song {
  code: string;
  title: string;
  artist: string;
  videoPath: string;
  firstLyric: string;
}

let songDatabase: Record<string, SongEntry> | null = null;

async function readIniFile(path: string): Promise<string> {
  try {
    const response = await fetch(`file://${path}/db.ini`);
    return await response.text();
  } catch (error) {
    console.error("Error reading db.ini:", error);
    throw error;
  }
}

export const readSongFromDb = async (code: string): Promise<Song | null> => {
  try {
    // Special case for testing with code 12345
    if (code === "12345") {
      return {
        code: "12345",
        title: "Test Song",
        artist: "Test Artist",
        videoPath:
          "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4",
        firstLyric: "This is a test song",
      };
    }

    // Normal case for other codes
    if (!songDatabase) {
      const dbPath = localStorage.getItem("dbPath") || "/media/usb";
      const iniContent = await readIniFile(dbPath);
      songDatabase = parseIniContent(iniContent);
    }

    const songEntry = songDatabase[code];
    if (!songEntry) return null;

    return {
      code,
      title: songEntry.musica,
      artist: songEntry.artista,
      videoPath: `file://${localStorage.getItem("dbPath") || "/media/usb"}/${songEntry.arquivo}`,
      firstLyric: songEntry.inicio,
    };
  } catch (error) {
    console.error("Error reading song from database:", error);
    return null;
  }
};

export const updateDbPath = (path: string) => {
  localStorage.setItem("dbPath", path);
  songDatabase = null; // Reset cache to force reload with new path
};
