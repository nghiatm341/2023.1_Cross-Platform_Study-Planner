const router = require('express').Router();
const LessonNote = require('../models/LessonNote');
const uuid = require('uuid');

router.post('/getAllLessonNotes', async (req, res) => {
    try{
        const {routeId, lessonId} = req.body;

        if(routeId && lessonId){
            const notes = await LessonNote.find({routeId: routeId, lessonId: lessonId});

            res.status(200).json({message: "Success", data: notes})
        }
        else{
            res.status(400).json({message: 'Missing data'});
        }

    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});

router.post('/createLessonNote', async (req, res) => {
    try {
        const {routeId, lessonId, noteContent} = req.body;

        if(routeId && lessonId){
            
            if(noteContent !== null && noteContent !== ''){

            const newNote = new LessonNote({
                noteId: uuid.v4(),
                routeId: routeId,
                lessonId: lessonId,
                content: noteContent
            })

            const note = await LessonNote.create(newNote);

            res.status(200).json({message: "Success", data: note})

            }
            else{
                res.status(400).json({message: 'Note dont have content'});
            }
        }
        else{
            res.status(400).json({message: 'Missing data'});
        }
    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});

router.post('/editLessonNote', async (req, res) => {
    try{
        const {noteId, newContent} = req.body;

        await LessonNote.findOneAndUpdate({noteId: noteId}, {
            $set: {
                content: newContent
            }
        });

        const data = {
            noteUpdated: noteId,
            newContent: newContent
        }

        res.status(200).json({message: "Success", data: data})

    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});

router.post('/deleteLessonNote', async (req, res) => {
    try{
        const {noteId} = req.body;

        const note = await LessonNote.findOneAndDelete({noteId: noteId});

        if(!note){
            return res.status(404).json({message: "Can't find note"})
        }
        else{
            res.status(200).json({message: "Delete succeed"});
        }

    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});

module.exports = router;