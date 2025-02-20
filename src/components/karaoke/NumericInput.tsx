import React, { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { motion } from "framer-motion";

interface NumericInputProps {
  onSubmit?: (code: string) => void;
  onChange?: (value: string) => void;
  maxLength?: number;
  isLoading?: boolean;
  size?: "normal" | "small";
  placeholder?: string;
}

const NumericInput = ({
  onSubmit = () => {},
  onChange = () => {},
  maxLength = 5,
  isLoading = false,
  size = "normal",
  placeholder = "Enter song code...",
}: NumericInputProps) => {
  const [inputValue, setInputValue] = useState("");

  const handleNumberClick = (number: string) => {
    if (inputValue.length < maxLength) {
      const newValue = inputValue + number;
      setInputValue(newValue);
      onChange(newValue);
    }
  };

  const handleDelete = () => {
    const newValue = inputValue.slice(0, -1);
    setInputValue(newValue);
    onChange(newValue);
  };

  const handleClear = () => {
    setInputValue("");
    onChange("");
  };

  const handleSubmit = () => {
    if (inputValue.length === maxLength) {
      onSubmit(inputValue);
      setInputValue("");
    }
  };

  const numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

  return (
    <Card
      className={`${size === "normal" ? "w-[400px] p-6" : "w-[300px] p-3"} bg-black/80 border border-gray-800`}
    >
      <div className="flex flex-col h-full gap-4">
        {/* Digital Display */}
        <div
          className={`flex justify-center items-center ${size === "normal" ? "h-24 text-5xl mb-6" : "h-12 text-2xl mb-4"} bg-black border-2 border-gray-700 rounded-lg font-mono tracking-[0.5em] text-white relative overflow-hidden`}
        >
          <div className="absolute inset-0 flex items-center px-6">
            <div className="flex gap-4 justify-center w-full">
              {Array(5)
                .fill(0)
                .map((_, i) => (
                  <span
                    key={i}
                    className={inputValue[i] ? "opacity-100" : "opacity-30"}
                  >
                    {inputValue[i] || "0"}
                  </span>
                ))}
            </div>
          </div>
        </div>

        {/* Numeric Keypad */}
        <div className="grid grid-cols-3 gap-2 flex-1">
          {numbers.slice(0, 9).map((num) => (
            <motion.div key={num} whileTap={{ scale: 0.95 }}>
              <Button
                variant="ghost"
                className={`w-full h-full ${size === "normal" ? "text-2xl" : "text-lg"} text-white hover:bg-white/10 transition-colors duration-200`}
                onClick={() => handleNumberClick(num)}
                disabled={isLoading}
              >
                {num}
              </Button>
            </motion.div>
          ))}
          <motion.div whileTap={{ scale: 0.95 }}>
            <Button
              variant="ghost"
              className="w-full h-full text-2xl text-red-500 hover:bg-red-500/10 hover:text-red-400 transition-colors duration-200"
              onClick={handleClear}
              disabled={isLoading}
            >
              C
            </Button>
          </motion.div>
          <motion.div whileTap={{ scale: 0.95 }}>
            <Button
              variant="ghost"
              className="w-full h-full text-2xl text-white hover:bg-white/10 transition-colors duration-200"
              onClick={() => handleNumberClick("0")}
              disabled={isLoading}
            >
              0
            </Button>
          </motion.div>
          <motion.div whileTap={{ scale: 0.95 }}>
            <Button
              variant="ghost"
              className="w-full h-full text-2xl text-yellow-500 hover:bg-yellow-500/10 hover:text-yellow-400 transition-colors duration-200"
              onClick={handleDelete}
              disabled={isLoading}
            >
              ←
            </Button>
          </motion.div>
        </div>

        {/* Enter Button */}
        <motion.div whileTap={{ scale: 0.95 }}>
          <Button
            className="w-full h-16 text-2xl bg-blue-600 hover:bg-blue-700 transition-colors duration-200"
            onClick={handleSubmit}
            disabled={inputValue.length !== maxLength || isLoading}
          >
            {isLoading ? "Loading..." : "Enter"}
          </Button>
        </motion.div>
      </div>
    </Card>
  );
};

export default NumericInput;
