# My First Transaction

In this section, we'll make our first transaction on the Coda network. After [installing the software](../getting-started), we'll need to create a new account before we can send or receive coda. Let's first start up the node so that we can start issuing commands.

## Start up a node

Run the following command to start up a Coda node instance and connect to the network:

    coda daemon -peer filet-mignon.o1test.net:8303

The host and port specified above refer to the seed peer address - this is the initial peer we will connect to on the network. Since Coda is a [peer-to-peer](../glossary/#peer-to-peer) protocol, there is no single centralized server we rely on. If you forwarded custom ports (other than 8302 for TCP), you'll need to pass an extra flag to the above command: `-external-port <custom-TCP-port>`.

!!!note
    The daemon process needs to be running whenever you issue commands from `coda client`, so make sure you don't kill it by accident.

See [here](/docs/troubleshooting/) for common issues when first running a node.

## Checking connectivity

Now that we've started up a node and are running the Coda daemon, open up another shell and run the following command:

    coda client status

!!!note
    For now, it may take up to a minute before `coda client status` connects to the daemon when first starting up. So if you see `Error: daemon not running. See coda daemon`, just a wait a bit and try again.

Most likely we will see a response that include the fields below:

    ...
    Peers:                                         Total: 4 (...)
    ...
    Sync Status:                                   Bootstrap

If you see `Sync Status: Bootstrap`, this means that the Coda node is bootstrapping and needs to sync with the rest of the network. You may need to be patient here as this step might take some time for the node to get all the data it needs. When sync status reaches `Synced` and the node is connected to 1 or more peers, we will have successfully connected to the network.


## Create a new account

Once our node is synced, we'll create a public/private key-pair so that we can sign transactions and generate an address to receive payments. For security reasons, we'll want to put the keys under a directory that is harder for attackers to access.

Run the following command which creates a public and private key `my-wallet` and `my-wallet.pub` under the `keys` directory:

    coda client generate-keypair -privkey-path keys/my-wallet

!!! warning
    The public key can be shared freely with anyone, but be very careful with your private key file. Never share this private key with anyone, as it is the equivalent of a password for your funds.

The response from this command will look like this:

    Keypair generated
    Public key: tNciWPvQgfUkdXyguKoBW1msCkwBtTmrioH5SrgU1V4gh2Th9q29x5DC6fQkJR2KqYGiAwaMoPQkQvr2Ltb6WvhMfb7JcC9TDi93YiUMuS7Nz25kZvWn83dY3NPpdF77at8VCkML1mYAQG

Since the public key is quite long and difficult to remember, let's save it as an environment variable:

    export CODA_PK=<public-key>

Now we can access this everywhere as `$CODA_PK`. Note that this will only be saved for the current shell session, so if you want to save it for future use, you can add it to your `~/.profile` or `~/.bash_profile`, by the command 

    echo export CODA_PK=[public-key] >> .bashrc , or .profile

## Request coda

In order to send our first transaction, we'll first need to get some coda to play with. Head over to the [Coda Discord server](https://bit.ly/CodaDiscord) and join the `#faucet` channel. Once there, ask Tiny the dog for some coda (you'll receive 100). Here's an example:

    $request <public-key>

Once a faucet-mod thumbs up your request, keep an eye on the Discord channel to see when the transaction goes through on that side. It may take a few minutes for your funds to appear.

We can check our balance to make sure that we received the funds by running the following command, passing in our public key:

    coda client get-balance -address $CODA_PK

You might see `No account found at that public_key (zero balance)`. Be patient! Depending on the traffic in the network, it may take a few blocks before your transaction goes through.

While you're waiting take a look at your daemon logs for new blocks being generated. Run the following command to see the current block height:

    coda client status

## Make a payment

Finally we get to the good stuff, sending our first transaction! For testing purposes, there's already an [echo service](https://github.com/CodaProtocol/coda-automation/tree/master/services/echo-service) set up that will immediately refund your payment minus the transaction fees.

!!! warning
    Currently, there is a known issue with the echo service that prevents it from properly echoing back your payment! Don't worry, we'll still give you Testnet Points[\*](#disclaimer) for completing the challenge.

Let's send some of our newly received coda to this service to see what a payment looks like:

    coda client send-payment \
      -amount 20 \
      -receiver tNciB5atiEC8k4poyYQX64WPZzSTt1pLYwujjiQeQtw9xaTPY5ZqVdcc6aP3MUVUVm8QTP7vcGPtGqZmDmozkjpZZKiMppMc4D6Dq8JScuPw5D9oCjAoYq431Ka8Ch2povNMJE7TYusPM3 \
      -fee 5 \
      -privkey-path keys/my-wallet

If you're wondering what we passed in to the commands above:

- For `amount`, we're sending a test value of `20` coda
- The `receiver` is the public key of the [echo service](https://github.com/CodaProtocol/coda-automation/tree/master/services/echo-service)
- For `fee`, let's use the current market rate of `5` coda
- The `privkey-path` is the private key file path of the private key we generated the `keys` folder

If this command is formatted properly, we should get a response that looks like the following:

    Dispatched payment with ID 3XCgvAHLAqz9VVbU7an7f2L5ffJtZoFega7jZpVJrPCYA4j5HEmUAx51BCeMc232eBWVz6q9t62Kp2cNvQZoNCSGqJ1rrJpXFqMN6NQe7x987sAC2Sd6wu9Vbs9xSr8g1AkjJoB65v3suPsaCcvvCjyUvUs8c3eVRucH4doa2onGj41pjxT53y5ZkmGaPmPnpWzdJt4YJBnDRW1GcJeyqj61GKWcvvrV6KcGD25VEeHQBfhGppZc7ewVwi3vcUQR7QFFs15bMwA4oZDEfzSbnr1ECoiZGy61m5LX7afwFaviyUwjphtrzoPbQ2QAZ2w2ypnVUrcJ9oUT4y4dvDJ5vkUDazRdGxjAA6Cz86bJqqgfMHdMFqpkmLxCdLbj2Nq3Ar2VpPVvfn2kdKoxwmAGqWCiVhqYbTvHkyZSc4n3siGTEpTGAK9usPnBnqLi53Z2bPPaJ3PuZTMgmdZYrRv4UPxztRtmyBz2HdQSnH8vbxurLkyxK6yEwS23JSZWToccM83sx2hAAABNynBVuxagL8aNZF99k3LKX6E581uSVSw5DAJ2S198DvZHXD53QvjcDGpvB9jYUpofkk1aPvtW7QZkcofBYruePM7kCHjKvbDXSw2CV5brHVv5ZBV9DuUcuFHfcYAA2TVuDtFeNLBjxDumiBASgaLvcdzGiFvSqqnzmS9MBXxYybQcmmz1WuKZHjgqph99XVEapwTsYfZGi1T8ApahcWc5EX9
    Receipt chain hash is now A3gpLyBJGvcpMXny2DsHjvE5GaNFn2bbpLLQqTCHuY3Nd7sqy8vDbM6qHTwHt8tcfqqBkd36LuV4CC6hVH6YsmRqRp4Lzx77WnN9gnRX7ceeXdCQUVB7B2uMo3oCYxfdpU5Q2f2KzJQ46

## Check account balance

Now that we can send transactions, it might be helpful to know our balance, so that we don't spend our testnet tokens too carelessly! Let's check our current balance by running the following command, passing in the public key of the account we generated:

    coda client get-balance -address $CODA_PK

We'll get a response that looks like this:

    Balance: 50 coda

Once you feel comfortable with the basics of creating an address, and sending & receiving coda, we can move on to the truly unique parts of the Coda network - [participating in consensus and helping compress the blockchain](/docs/node-operator).

<span id="disclaimer">
\*_Testnet Points are designed solely to track contributions to the Testnet and Testnet Points have no cash or other monetary value. Testnet Points are not transferable and are not redeemable or exchangeable for any cryptocurrency or digital assets. We may at any time amend or eliminate Testnet Points._
</span>

