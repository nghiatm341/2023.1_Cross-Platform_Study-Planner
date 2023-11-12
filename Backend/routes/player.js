const router = require('express').Router();
const Player = require('../models/Player');

//get list
router.get('/player-list',  async (req, res) => {
    try{
        const players = await Player.find();
        res.status(200).json(players);
       }
       catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
       }
});

//find by ID
router.get('/players/:id', async (req, res) =>{
    try{
        const {id} = req.params;
        const player = await Player.findById(id);
        res.status(200).json(player);
       }
       catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
       }
})

//create
router.post('/create', async (req, res) =>{
   try{
    const player = await Player.create(req.body);
    res.status(200).json(player);
   }
   catch(error){
    console.log(error.message);
    res.status(500).json({message: error.message});
   }
})

//edit
router.put('/players/:id', async (req, res) => {
    try{
        const {id} = req.params;
        const player = await Player.findByIdAndUpdate(id, req.body)

        if(!player){
            return res.status(404).json({message: "Can't find player"})
        }
        else{
            const updatedPlayer = await Player.findById(id)
            res.status(200).json(updatedPlayer);
        }
       }
       catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
       }
})

//delete
router.delete('/players/:id', async (req, res) => {
    try{
        const {id} = req.params;
        const player = await Player.findByIdAndDelete(id);

        if(!player){
            return res.status(404).json({message: "Can't find player"})
        }
        else{
            res.status(200).json({message: "Delete succeed"});
        }

       }
       catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
       }
} )

module.exports = router;