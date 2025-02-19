import React, { useEffect, useState } from "react";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { motion, AnimatePresence } from "framer-motion";

interface ScoreDisplayProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  score: number;
  accuracy: number;
}

const ScoreDisplay = ({
  open,
  onOpenChange,
  score = 85,
  accuracy = 90,
}: ScoreDisplayProps) => {
  const [autoClose, setAutoClose] = useState<NodeJS.Timeout>();

  useEffect(() => {
    if (open) {
      const timer = setTimeout(() => {
        onOpenChange(false);
      }, 5000);
      setAutoClose(timer);
    }
    return () => {
      if (autoClose) clearTimeout(autoClose);
    };
  }, [open, onOpenChange]);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-gray-900/95 border-none">
        <AnimatePresence>
          {open && (
            <motion.div
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.8, opacity: 0 }}
              className="text-center p-6"
            >
              <motion.h2
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                className="text-4xl font-bold text-primary mb-4"
              >
                Score: {score}
              </motion.h2>
              <motion.div
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.2 }}
                className="text-2xl text-white mb-4"
              >
                Accuracy: {accuracy}%
              </motion.div>
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.4, type: "spring" }}
                className="text-6xl mb-4"
              >
                {score >= 90 ? "🌟" : score >= 70 ? "👏" : "👍"}
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>
      </DialogContent>
    </Dialog>
  );
};

export default ScoreDisplay;
