import { useEffect } from "react";
import { useNetworkLayer } from "./ui/hooks/useNetworkLayer";
import { PhaserLayer } from "./phaser/phaserLayer";
import { store } from "./store";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { NavBar } from "./ui/components/NavBar";
import { AboutGame } from "./ui/components/About";
import { Leaderboard } from "./ui/components/Leaderboard";
import { Settings } from "./ui/components/Settings";

const router = createBrowserRouter([
    {
        path: "/",
        element: <PhaserLayer />,
    },
    {
        path: "/about",
        element: <AboutGame />,
    },
    {
        path: "/leaderboard",
        element: <Leaderboard />,
    },
    {
        path: "/settings",
        element: <Settings />,
    },
]);

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
            <NavBar />
            <RouterProvider router={router} />
        </div>
    );
}

export default App;
