const router = require('express').Router();
const StudyRoute = require('../models/StudyRoute')
const Lesson = require('../models/Lesson')
const uuid = require('uuid');
const authMiddleware = require('../middlewares/auth.middleware');
const {ROLE} = require('../constant/enum')


//get all in-progress study routes  of a user 
router.post('/getAllInProgressRoutes', async (req, res) => {
    try {
        const {userId} = req.body;

        if(userId){
            const allInProgressStudyRoutes = await StudyRoute.find({userId: userId, isFinished: false}).sort({createdAt: -1})

            res.status(200).json({message: "Success", data: allInProgressStudyRoutes})
        }
        else{
            res.status(400).json({message: 'missing data'});
        }

    } catch (error) {
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});


//get all finished study routes  of a user 
router.post('/getAllFinishedRoutes', async (req, res) => {
    try {
        const {userId} = req.body;

        if(userId){
            const allFinishedStudyRoutes = await StudyRoute.find({userId: userId, isFinished: true}).sort({finishedAt: -1})

            res.status(200).json({message: "Success", data: allFinishedStudyRoutes})
        }
        else{
            res.status(400).json({message: 'missing data'});
        }

    } catch (error) {
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});

router.post('/createStudyRoute', async (req, res) => {
    try {
        const {courseId, userId} = req.body;

        const courseLessonList = await Lesson.find({ course_id: courseId, is_delete: 0 }).sort({id: 1, lesson_before_id: 1})

        const studyRouteLesson = courseLessonList.map((item) => {
            return {
                lessonId: item.id,
                studyTime: Math.ceil(item.estimate_time),
                isCompleted: false,
                completedAt: new Date()
            }
        });

        const newRoute = new StudyRoute({
            routeId: uuid.v4(),
            userId: userId,
            courseId: courseId,
            createdAt: new Date(),
            isFinished: false,
            finishedAt: new Date(),
            lessons: studyRouteLesson
        })

        const result = await newRoute.save();
        res.status(200).json({ message: 'create route success', data: result })
    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});


// get detail info of a study route, include lessons info
router.post('/getStudyRouteDetail', async (req, res) => {
    try {
        const {routeId} = req.body;

        const routeData = await StudyRoute.findOne({routeId: routeId})

        const courseLessonList = await Lesson.find({ course_id: routeData.courseId, is_delete: 0 }).sort({ lesson_before_id: 1, id: 1 })

        const data = {
            routeId: routeId,
            courseId: routeData.courseId,
            customLessons: routeData.lessons,
            lessonData: courseLessonList,
            createdAt: routeData.createdAt
        }
    
        res.status(200).json({message: "Success", data: data})
    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});


router.post('/changeLessonStudyTime', authMiddleware.authRoleMiddleware(ROLE.STUDENT), async (req, res) => {
    try{
        const {routeId, lessonId, newStudyTime} = req.body;

        const routeData = await StudyRoute.findOne({routeId: routeId})

        const lessons = routeData.lessons;

        const needUpdateLesson = lessons.find(lesson => lesson.lessonId == lessonId);

        if(needUpdateLesson){
            needUpdateLesson.studyTime = newStudyTime;

            await StudyRoute.findOneAndUpdate({routeId: routeId}, 
                { 
                    $set: {
                        lessons: lessons
                    }
                })

            const data = {
                lessonUpdated: lessonId,
                newStudyTime: newStudyTime
            }

            res.status(200).json({message: "Success", data: data})

        }
        else{
            res.status(500).json({message: "Lesson need complete not found"});
        }

    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});

router.post('/completeLesson', async(req, res) => {
    try{
        const {routeId, lessonId} = req.body;

        const routeData = await StudyRoute.findOne({routeId: routeId})

        const lessons = routeData.lessons;

        const needUpdateLesson = lessons.find(lesson => lesson.lessonId == lessonId);

        if(needUpdateLesson){

            const index = lessons.indexOf(needUpdateLesson);

            if(index > 0 &&  lessons[index-1].isCompleted == false){
                res.status(300).json({message: "Failed"})
            }
            else{
                needUpdateLesson.isCompleted = true;
                needUpdateLesson.completedAt = new Date();
    
                const incompleteLesson = lessons.find(lesson => lesson.isCompleted == false);
    
                const isCompleteCourse = (incompleteLesson == null)
    
                await StudyRoute.findOneAndUpdate({routeId: routeId}, 
                    { 
                        $set: {
                            lessons: lessons,
                            isFinished: isCompleteCourse,
                            finishedAt: new Date()
                        }
                    })
    
                const data = {
                    isCompleteCourse: isCompleteCourse,
                    lessonComplete: lessonId
                }
    
    
                res.status(200).json({message: "Success", data: data})
            }
        }
        else{
            res.status(500).json({message: "Lesson need complete not found"});
        }


    }
    catch(error){
        console.log(error.message);
        res.status(500).json({message: error.message});
    }
});


router.post('/deleteStudyRoute', async (req, res) => {
    try{
        const {routeId} = req.body;

        const route = StudyRoute.findOneAndDelete({routeId: routeId});

        if(!route){
            return res.status(404).json({message: "Can't find route"})
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

router.post('/deleteStudyRouteWhenUnsubscribe', async (req, res) => {
    try{
        const {courseId, userId} = req.body;

        const route = await StudyRoute.findOneAndDelete({courseId: courseId, userId: userId});

        if(!route){
            return res.status(300).json({message: "Can't find route"})
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

module.exports = router






