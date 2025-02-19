export interface SongEntry {
  arquivo: string;
  artista: string;
  musica: string;
  inicio: string;
}

export function parseIniContent(content: string): Record<string, SongEntry> {
  const songs: Record<string, SongEntry> = {};
  let currentSection = "";

  const lines = content.split("\n");

  for (const line of lines) {
    const trimmedLine = line.trim();
    if (!trimmedLine || trimmedLine.startsWith(";")) continue;

    const sectionMatch = trimmedLine.match(/\[(\d+)\]/);
    if (sectionMatch) {
      currentSection = sectionMatch[1];
      songs[currentSection] = {} as SongEntry;
      continue;
    }

    if (currentSection) {
      const [key, ...valueParts] = trimmedLine.split("=");
      const value = valueParts.join("=").trim();
      if (key && value) {
        songs[currentSection][key.trim() as keyof SongEntry] = value;
      }
    }
  }

  return songs;
}
