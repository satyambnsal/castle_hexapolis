import { useEffect } from "react";
import { useNetworkLayer } from "./ui/hooks/useNetworkLayer";
import { PhaserLayer } from "./phaser/PhaserLayer";
import { store } from "./store";
import { NewGame } from "./ui/NewGame";
// import { UI } from "./ui";
// import { NewGame } from "./ui/NewGame";

function App() {
    const networkLayer = useNetworkLayer();
    const { loggedIn, username } = store();

    useEffect(() => {
        if (!networkLayer || !networkLayer.account) return;
        store.setState({ networkLayer });
        console.log(
            "########## Account Address ###########\n",
            networkLayer.account.address,
            "\n############"
        );
        // Handle Lord Faucet thing here.
    }, [networkLayer]);

    console.log(networkLayer, loggedIn);
    return (
        <div className="w-full h-screen flex justify-center items-center bg-[#ded6b6]">
            {!networkLayer ? (
                <div className="text-3xl">Loading...</div>
            ) : true ? (
                <PhaserLayer networkLayer={networkLayer} />
            ) : (
                <NewGame />
            )}
        </div>
    );
}

export default App;
