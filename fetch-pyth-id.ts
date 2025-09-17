import {
    SuiPythClient,
    SuiPriceServiceConnection,
} from "@pythnetwork/pyth-sui-js";
import { SuiClient } from "@mysten/sui/client";


const suiClient = new SuiClient({ url: "https://fullnode.mainnet.sui.io:443" });

async function main() {

    if(process.argv.length < 3) {
        console.log("Please provide a price ID");
        process.exit(1);
    }

    const priceID = process.argv[2];

    console.log("Price ID: ", priceID);

    const pythStateId =
        "0x1f9310238ee9298fb703c3419030b35b22bb1cc37113e3bb5007c99aec79e5b8";
    const wormholeStateId =
        "0xaeab97f96cf9877fee2883315d459552b2b921edc16d7ceac6eab944dd88919c";

    const pythClient = new SuiPythClient(
        suiClient,
        pythStateId,
        wormholeStateId
    );

    const priceFeedObjectId = await pythClient.getPriceFeedObjectId(priceID);
    console.log("Price Feed Object ID: ", priceFeedObjectId);

   
}

main();
