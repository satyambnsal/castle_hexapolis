import { useEffect } from "react";
import { useNetworkLayer } from "./ui/hooks/useNetworkLayer";
import { PhaserLayer } from "./phaser/phaserLayer";
import { store } from "./store";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { NavBar } from "./ui/components/NavBar";
import { AboutGame } from "./ui/components/About";
import { Leaderboard } from "./ui/components/Leaderboard";
import { Settings } from "./ui/components/Settings";

function App() {
    const networkLayer = useNetworkLayer();

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

    return (
        <div className=" bg-[#ded6b6] mb-0">
            <BrowserRouter>
                <NavBar />
                <Routes>
                    <Route path="/" element={<PhaserLayer />}></Route>
                    <Route path="about" element={<AboutGame />} />
                    <Route path="leaderboard" element={<Leaderboard />} />
                    <Route path="settings" element={<Settings />} />
                </Routes>
            </BrowserRouter>
        </div>
    );
}

export default App;
