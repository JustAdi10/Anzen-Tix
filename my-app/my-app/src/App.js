import React, { useEffect, useState } from 'react';
import Web3 from 'web3';
import MyContract from './contracts/MyContract.json';
import './App.css';

function App() {
  const [account, setAccount] = useState('');
  const [contract, setContract] = useState(null);

  useEffect(() => {
    const init = async () => {
      const web3 = new Web3(Web3.givenProvider || 'http://localhost:8545');
      const accounts = await web3.eth.requestAccounts();
      setAccount(accounts[0]);

      const networkId = await web3.eth.net.getId();
      const deployedNetwork = MyContract.networks[networkId];
      const instance = new web3.eth.Contract(
        MyContract.abi,
        deployedNetwork && deployedNetwork.address,
      );
      setContract(instance);
    };

    init();
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <p>Your account: {account}</p>
        {/* Add more UI elements to interact with your contract */}
      </header>
    </div>
  );
}

export default App;
