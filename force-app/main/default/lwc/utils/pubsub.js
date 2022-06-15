const events = {};

export default class Pubsub {
    static subscribe = (eventName, callback, thisArg) => {
        if (!thisArg) {
            throw new Error('"this" argument is required');
        }

        if (!events[eventName]) {
            events[eventName] = [];
        }

        if (!Pubsub.isSubscribed(eventName, callback, thisArg)) {
            events[eventName].push({ callback, thisArg });
        }
    };

    static unsubscribe = (eventName, callback, thisArg) => {
        if (events[eventName]) {
            events[eventName] = events[eventName].filter(
                (listener) => listener.callback !== callback || listener.thisArg !== thisArg
            );
        }
    };

    static isSubscribed = (eventName, callback, thisArg) => {
        return (events[eventName] || []).some(
            (listener) => listener.callback === callback && listener.thisArg === thisArg
        );
    };

    static publish = (eventName, data) => {
        if (events[eventName]) {
            const listeners = events[eventName];
            listeners.forEach((listener) => {
                try {
                    listener.callback.call(listener.thisArg, data);
                } catch (error) {
                    // fail silently
                }
            });
        }
    };
}