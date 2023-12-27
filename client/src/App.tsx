import { useEffect } from "react";
// import { useNetworkLayer } from "./ui/hooks/useNetworkLayer";
// import { PhaserLayer } from "./phaser/phaserLayer";
// import { store } from "./store";
// import { UI } from "./ui";
import "./phaser/phaser-hex/Game";

function App() {
    // const networkLayer = useNetworkLayer();

    // useEffect(() => {
    //     if (!networkLayer || !networkLayer.account) return;

    //     console.log("Setting network layer");

    //     store.setState({ networkLayer });
    // }, [networkLayer]);

    return (
        <div>
            {/* <div className="w-full h-screen flex justify-center items-center">
                <div className="self-center">
                    {!networkLayer && "loading..."}
                </div>
            </div> */}
            {/* <PhaserLayer networkLayer={networkLayer} /> */}
            {/* <h1>Hello World 1</h1> */}
            <div id="hex-game" />
            {/* <UI /> */}
        </div>
    );
}

export default App;
