import React, { useState, useEffect } from 'react'

import { DisplayCampaigns } from '../components';
import { useStateContext } from '../context'

const Home = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [campaigns, setCampaigns] = useState([]);

  const { address, contract, getCampaigns } = useStateContext();

  const fetchCampaigns = async () => {
    setIsLoading(true);
    const data = await getCampaigns();
    setCampaigns(data);
    setIsLoading(false);
  }

  useEffect(() => {
    if(contract) fetchCampaigns();
  }, [address, contract]);

  return (
      <><div className='h-96 flex items-center my-[20px] bg-[#ffffff] p-4 rounded-[10px]'>
        <p className='text-[64px]'>A supporter is worth a thousand followers.</p>
        <p className='text-[24px]'>Accept donations. Start a membership. Sell anything you like. It’s easier than you think.</p>
      </div>
      <DisplayCampaigns 
        title="All PizzaShares"
        isLoading={isLoading}
        campaigns={campaigns}
      />
    </>
  )
}

export default Home