const TASK_ROLE_TITLE = 0;
const TASK_ROLE_ICON = 1;
const TASK_ROLE_GEOMETRY = 289;

function updateTasks(tasksModel, tasksContainer) {
    destroyTaskItems(tasksContainer);
    const tasks = extractTasks(tasksModel);
    createTaskItems(tasksContainer, tasks);
}

function destroyTaskItems(tasksContainer) {
    for (const taskItem of tasksContainer.taskItems) {
       taskItem.destroy();
    }
    tasksContainer.taskItems = [];
}

function createTaskItems(tasksContainer, tasks) {
    for (const task of tasks) {
        const taskItem = taskComponent.createObject(tasksContainer, { model: task });
        tasksContainer.taskItems.push(taskItem);
    }
}

function extractTasks(tasksModel) {
    const n = tasksModel.rowCount();
    const tasks = new Array(n);
    for (let i = 0; i < n; i++) {
        const taskIndex = tasksModel.index(i, 0);
        tasks[i] = {
            decoration: tasksModel.data(taskIndex, TASK_ROLE_ICON),
            Geometry: tasksModel.data(taskIndex, TASK_ROLE_GEOMETRY),
        };
    }
    return tasks;
}
