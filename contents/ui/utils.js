const TASK_ROLE_TITLE = 0;
const TASK_ROLE_ICON = 1;
const TASK_ROLE_GEOMETRY = 289;
const TASK_ROLE_FOCUSED = 272;
const TASK_ROLE_MINIMIZED = 279;
const TASK_ROLE_MINIMIZED2 = 300;

function updateTasks(tasksModel, tasksContainer) {
    destroyTaskItems(tasksContainer);
    const tasks = extractTasks(tasksModel);
    const [minimizedTasks, normalTasks] = splitMinimizedTasks(tasks);
    sortTasks(normalTasks);
    createTaskItems(tasksContainer, normalTasks);
    if (showMinimized && minimizedTasks.length > 0) {
        createTaskItem(tasksContainer, taskSeparatorComponent);
        createTaskItems(tasksContainer, minimizedTasks);
    }
}

function destroyTaskItems(tasksContainer) {
    for (const taskItem of tasksContainer.taskItems) {
       taskItem.destroy();
    }
    tasksContainer.taskItems = [];
}

function createTaskItem(tasksContainer, component) {
    const taskItem = component.createObject(tasksContainer);
    tasksContainer.taskItems.push(taskItem);
}

function createTaskItemWithProperties(tasksContainer, component, properties) {
    const taskItem = component.createObject(tasksContainer, properties);
    tasksContainer.taskItems.push(taskItem);
}

function createTaskItems(tasksContainer, tasks) {
    for (const task of tasks) {
        createTaskItemWithProperties(tasksContainer, taskComponent, { model: task });
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
            IsActive: tasksModel.data(taskIndex, TASK_ROLE_FOCUSED),
        };
    }
    return tasks;
}

function splitMinimizedTasks(tasks) {
    const minimized = [];
    const normal = [];
    for (const task of tasks) {
        if (task.IsMinimized) {
            minimized.push(task);
        } else {
            normal.push(task);
        }
    }
    return [minimized, normal];
}

function sortTasks(tasks) {
    tasks.sort((a, b) => {
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
    });
}
