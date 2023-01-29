const TASK_ROLE_TITLE = 0;
const TASK_ROLE_ICON = 1;
const TASK_ROLE_GEOMETRY = 289;
const TASK_ROLE_MINIMIZED = 279;
const TASK_ROLE_MINIMIZED2 = 300;

function updateTasks(tasksModel, tasksContainer) {
    destroyTaskItems(tasksContainer);
    const tasks = extractTasks(tasksModel);
    sortTasks(tasks);
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
            IsMinimized: tasksModel.data(taskIndex, TASK_ROLE_MINIMIZED),
        };
    }
    return tasks;
}

function sortTasks(tasks) {
    tasks.sort((a, b) => {
        if (a.IsMinimized && !b.IsMinimized) {
            return -1;
        } else if (!a.IsMinimized && b.IsMinimized) {
            return 1;
        } else {
            if (a.Geometry.x < b.Geometry.x) {
                return -1;
            } else if (a.Geometry.x > b.Geometry.x) {
                return 1;
            } else {
                if (a.Geometry.y < b.Geometry.y) {
                    return -1;
                } else if (a.Geometry.y > b.Geometry.y) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    });
}
