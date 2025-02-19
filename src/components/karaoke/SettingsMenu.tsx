import React from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Switch } from "@/components/ui/switch";
import { Slider } from "@/components/ui/slider";

interface SettingsMenuProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  settings: {
    credits: {
      value: number;
      costPerSong: number;
      autoDeduct: boolean;
    };
    playback: {
      defaultVolume: number;
      autoplay: boolean;
      videoQuality: "low" | "medium" | "high";
      showNotes: boolean;
    };
    storage: {
      useExternalUSB: boolean;
      dbPath: string;
      customBackground: string;
    };
  };
  onSettingsChange: (key: string, value: any) => void;
}

const SettingsMenu = ({
  open,
  onOpenChange,
  settings,
  onSettingsChange,
}: SettingsMenuProps) => {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-gray-900 text-white max-w-2xl">
        <DialogHeader>
          <DialogTitle>Settings Menu</DialogTitle>
        </DialogHeader>
        <Tabs defaultValue="credits" className="w-full">
          <TabsList className="grid w-full grid-cols-3">
            <TabsTrigger value="credits">Credits</TabsTrigger>
            <TabsTrigger value="playback">Playback</TabsTrigger>
            <TabsTrigger value="storage">Storage</TabsTrigger>
          </TabsList>

          <TabsContent value="credits" className="space-y-4">
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="creditValue">Credit Value</Label>
                <Input
                  id="creditValue"
                  type="number"
                  value={settings.credits.value}
                  onChange={(e) =>
                    onSettingsChange("credits.value", Number(e.target.value))
                  }
                  className="bg-gray-800 text-white"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="costPerSong">Cost per Song</Label>
                <Input
                  id="costPerSong"
                  type="number"
                  value={settings.credits.costPerSong}
                  onChange={(e) =>
                    onSettingsChange(
                      "credits.costPerSong",
                      Number(e.target.value),
                    )
                  }
                  className="bg-gray-800 text-white"
                />
              </div>
              <div className="flex items-center justify-between">
                <Label htmlFor="autoDeduct">Auto-deduct Credits</Label>
                <Switch
                  id="autoDeduct"
                  checked={settings.credits.autoDeduct}
                  onCheckedChange={(checked) =>
                    onSettingsChange("credits.autoDeduct", checked)
                  }
                />
              </div>
            </div>
          </TabsContent>

          <TabsContent value="playback" className="space-y-4">
            <div className="space-y-4">
              <div className="space-y-2">
                <Label>Default Volume</Label>
                <Slider
                  value={[settings.playback.defaultVolume]}
                  onValueChange={([value]) =>
                    onSettingsChange("playback.defaultVolume", value)
                  }
                  max={100}
                  step={1}
                />
              </div>
              <div className="flex items-center justify-between">
                <Label htmlFor="autoplay">Autoplay</Label>
                <Switch
                  id="autoplay"
                  checked={settings.playback.autoplay}
                  onCheckedChange={(checked) =>
                    onSettingsChange("playback.autoplay", checked)
                  }
                />
              </div>
              <div className="space-y-2">
                <Label>Video Quality</Label>
                <div className="flex gap-2">
                  {["low", "medium", "high"].map((quality) => (
                    <Button
                      key={quality}
                      variant={
                        settings.playback.videoQuality === quality
                          ? "default"
                          : "outline"
                      }
                      onClick={() =>
                        onSettingsChange("playback.videoQuality", quality)
                      }
                      className="flex-1"
                    >
                      {quality.charAt(0).toUpperCase() + quality.slice(1)}
                    </Button>
                  ))}
                </div>
              </div>
              <div className="flex items-center justify-between">
                <Label htmlFor="showNotes">Show Notes</Label>
                <Switch
                  id="showNotes"
                  checked={settings.playback.showNotes}
                  onCheckedChange={(checked) =>
                    onSettingsChange("playback.showNotes", checked)
                  }
                />
              </div>
            </div>
          </TabsContent>

          <TabsContent value="storage" className="space-y-4">
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <Label htmlFor="useExternalUSB">Use External USB</Label>
                <Switch
                  id="useExternalUSB"
                  checked={settings.storage.useExternalUSB}
                  onCheckedChange={(checked) =>
                    onSettingsChange("storage.useExternalUSB", checked)
                  }
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="dbPath">Database Path</Label>
                <Input
                  id="dbPath"
                  value={settings.storage.dbPath}
                  onChange={(e) => {
                    const newPath = e.target.value;
                    onSettingsChange("storage.dbPath", newPath);
                    import("@/lib/songDatabase").then(({ updateDbPath }) => {
                      updateDbPath(newPath);
                    });
                  }}
                  className="bg-gray-800 text-white"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="customBackground">Custom Background</Label>
                <Input
                  id="customBackground"
                  type="file"
                  accept="image/*"
                  className="bg-gray-800 text-white"
                  onChange={(e) => {
                    const file = e.target.files?.[0];
                    if (file) {
                      const reader = new FileReader();
                      reader.onloadend = () => {
                        onSettingsChange(
                          "storage.customBackground",
                          reader.result,
                        );
                      };
                      reader.readAsDataURL(file);
                    }
                  }}
                />
              </div>
            </div>
          </TabsContent>
        </Tabs>
      </DialogContent>
    </Dialog>
  );
};

export default SettingsMenu;
