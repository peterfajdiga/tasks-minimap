const TASK_ROLE_TITLE = 0;
const TASK_ROLE_ICON = 1;
const TASK_ROLE_GEOMETRY = 289;
const TASK_ROLE_FOCUSED = 272;
const TASK_ROLE_MINIMIZED = 279;
const TASK_ROLE_MINIMIZED2 = 300;

function updateTasks(tasksModel, tasksContainer) {
    const tasks = extractTasks(tasksModel);
    const [minimizedTasks, normalTasks] = splitMinimizedTasks(tasks);
    sortTasks(normalTasks);

    let groups = groupTasks(normalTasks, task => task.Geometry.x);
    if (showMinimized && minimizedTasks.length > 0) {
        const minimizedGroups = groupTasks(minimizedTasks, task => task);
        groups = groups.concat(minimizedGroups);
    }
    tasksContainer.taskGroups = groups;
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
            tasksManagerIndex: taskIndex,
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

function groupTasks(tasks, getGroupKey) {
    const groups = [];
    let lastGroupKey = undefined;
    let lastGroup = undefined;
    for (const task of tasks) {
        const groupKey = getGroupKey(task);
        if (groupKey !== lastGroupKey) {
            lastGroupKey = groupKey;
            lastGroup = [];
            groups.push(lastGroup);
        }
        lastGroup.push(task);
    }
    return groups;
}

function colorAlpha(color, alpha) {
    return Qt.rgba(color.r, color.g, color.b, alpha);
}
