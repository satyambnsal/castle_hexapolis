import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { createPhaserLayer } from "../../phaser";
import { NetworkLayer } from "../../dojo/createNetworkLayer";
// import { phaserConfig } from "../../phaser/config/configurePhaser";
import { usePromiseValue } from "./usePromiseValue";

import { config as phaserConfig } from "../../phaser/phaser-config";

type Props = {
    networkLayer: NetworkLayer | null;
};

const createContainer = () => {
    const container = document.createElement("div");
    container.style.width = "100%";
    container.style.height = "100%";
    container.style.pointerEvents = "all";
    container.style.overflow = "hidden";
    container.id = "hex-game";
    return container;
};

export const usePhaserLayer = ({ networkLayer }: Props) => {
    const parentRef = useRef<HTMLElement | null>(null);
    // const [{ width, height }] = useState({ width: 0, height: 0 });

    const { phaserLayerPromise, container } = useMemo(() => {
        if (!networkLayer) return { container: null, phaserLayerPromise: null };

        const container = createContainer();
        if (parentRef.current) {
            parentRef.current.appendChild(container);
        }

        return {
            container,
            phaserLayerPromise: createPhaserLayer(networkLayer, {
                ...phaserConfig,
            }),
        };
    }, [networkLayer]);

    useEffect(() => {
        return () => {
            phaserLayerPromise?.then((phaserLayer) =>
                phaserLayer.world.dispose()
            );
            container?.remove();
        };
    }, [container, phaserLayerPromise]);

    const phaserLayer = usePromiseValue(phaserLayerPromise);

    const ref = useCallback(
        (el: HTMLElement | null) => {
            parentRef.current = el;
            if (container) {
                if (parentRef.current) {
                    parentRef.current.appendChild(container);
                } else {
                    container.remove();
                }
            }
        },
        [container]
    );

    return useMemo(() => ({ ref, phaserLayer }), [ref, phaserLayer]);
};
