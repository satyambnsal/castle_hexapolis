/* eslint-disable @typescript-eslint/no-non-null-assertion */

import { BurnerManager } from "@dojoengine/create-burner";
import { Account, RpcProvider } from "starknet";

export const createBurner = async () => {
    const rpcProvider = new RpcProvider({
        nodeUrl: import.meta.env.VITE_PUBLIC_NODE_URL!,
    });

    const masterAccount = new Account(
        rpcProvider,
        import.meta.env.VITE_PUBLIC_MASTER_ADDRESS!,
        import.meta.env.VITE_PUBLIC_MASTER_PRIVATE_KEY!
    );

    const burnerManager = new BurnerManager({
        masterAccount,
        accountClassHash: import.meta.env.VITE_PUBLIC_ACCOUNT_CLASS_HASH!,
        rpcProvider,
    });

    try {
        await burnerManager.create();
        console.log("### BurnerManager created successfully!! ✅ ###");
    } catch (e) {
        console.log(e);
    }

    burnerManager.init();

    return {
        account: burnerManager.account as Account,
        burnerManager,
    };
};
