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
    const tasks = [];
    for (let i = 0; i < n; i++) {
        const taskIndex = tasksModel.index(i, 0);
        const geometry = tasksModel.data(taskIndex, TASK_ROLE_GEOMETRY);
        if (geometry === undefined) {
            continue;
        }
        tasks.push({
            decoration: tasksModel.data(taskIndex, TASK_ROLE_ICON),
            Geometry: geometry,
            IsMinimized: tasksModel.data(taskIndex, TASK_ROLE_MINIMIZED),
            IsActive: tasksModel.data(taskIndex, TASK_ROLE_FOCUSED),
            tasksManagerIndex: taskIndex,
        });
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
        // using center instead of top-left corner works better with maximized windows
        const aX = a.Geometry.x + a.Geometry.width / 2;
        const bX = b.Geometry.x + b.Geometry.width / 2;
        if (aX < bX) {
            return -1;
        } else if (aX > bX) {
            return 1;
        } else {
            const aY = a.Geometry.y + a.Geometry.height / 2;
            const bY = b.Geometry.y + b.Geometry.height / 2;
            if (aY < bY) {
                return -1;
            } else if (aY > bY) {
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
