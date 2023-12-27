import Phaser from "phaser";
import { LoadScene, MainScene, MenuScene } from "./scenes";

export const config: Phaser.Types.Core.GameConfig = {
    width: 1280,
    height: 720,
    parent: "hex-game",
    type: Phaser.AUTO,
    scene: [LoadScene, MenuScene, MainScene],
    backgroundColor: "0xded6b6",
    scale: {
        autoCenter: Phaser.Scale.CENTER_BOTH,
        mode: Phaser.Scale.FIT,
    },
};

export default new Phaser.Game(config);
