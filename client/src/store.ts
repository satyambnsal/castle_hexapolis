import { create } from "zustand";
import { NetworkLayer } from "./dojo/createNetworkLayer";
import { PhaserLayer } from "./phaser";

export type Store = {
    networkLayer: NetworkLayer | null;
    phaserLayer: PhaserLayer | null;
    username: string;
    setUsername: (username: string) => void;
    loggedIn: boolean;
    setLoggedIn: (loggedIn: boolean) => void;
};

export const store = create<Store>((set) => ({
    networkLayer: null,
    phaserLayer: null,
    loggedIn: false,
    setLoggedIn: (loggedIn: boolean) => set(() => ({ loggedIn })),
    username: "",
    setUsername: (username: string) => set(() => ({ username })),
}));
