import { useEffect, useState } from "react";
import { LoadScene, MainScene, MenuScene } from "./scenes";
import clsx from "clsx";
import { EVENTS } from "./constants";
import { useNetworkLayer } from "../ui/hooks/useNetworkLayer";
import { setup } from "../dojo/setup";

export const PhaserLayer = () => {
    const networkLayer = useNetworkLayer();
    const [isReady, setReady] = useState(false);
    const [game, setGame] = useState<Phaser.Game | null>();

    useEffect(() => {
        const config: Phaser.Types.Core.GameConfig = {
            width: 1280,
            height: "100%",
            parent: "castle-hex",
            type: Phaser.AUTO,
            scene: [LoadScene, MenuScene, MainScene],
            backgroundColor: "0xded6b6",
            scale: {
                autoCenter: Phaser.Scale.CENTER_BOTH,
                mode: Phaser.Scale.FIT,
            },
            callbacks: {
                postBoot: async (game) => {
                    try {
                        const networkLayer = await setup();
                        game.registry.set("networkLayer", networkLayer);
                        console.log("setting in postboot", networkLayer);
                    } catch (err) {
                        console.log(
                            `Failed to setup network layer in main -> create`
                        );
                    }
                },
            },
        };

        const game = new Phaser.Game(config);
        
        game.events.on("gameIsReday", setReady);
        game.events.on(EVENTS.NETWORK_CONNECTION_FAILED, () => {
            alert("Failed to connect with katana network");
        });
        setGame(game);
        return () => {
            setReady(false);
            game.destroy(true);
        };
    }, []);

    if (!networkLayer) return null;

    return (
        <div
            id="castle-hex"
            className={clsx("bg-red", {
                hidden: !isReady,
            })}
        />
    );
};
