import React, { FC } from "react";
import NewGameButton from "./NewGameButton";
import { store } from "../store";

export const NewGame = () => {
    const { setLoggedIn, setUsername, username } = store();

    const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = event.target.value;
        setUsername(value);
    };

    const login = () => {
        setLoggedIn(true);
    };

    return (
        <div className="w-full flex flex-col items-center justify-center">
            <h1 className="font-bold text-3xl mb-8">Castle Hexapolis</h1>
            <div className="w-full max-w-xs">
                <label
                    className="block text-[#fae8c8] text-sm font-bold mb-2"
                    htmlFor="pseudo"
                >
                    Username
                </label>
                <input
                    className="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline text-gray-600"
                    id="pseudo"
                    type="text"
                    placeholder="Pseudo"
                    value={username}
                    onChange={handleInputChange}
                    maxLength={18}
                />
            </div>
            <NewGameButton onClick={login} disabled={!username} />
        </div>
    );
};
