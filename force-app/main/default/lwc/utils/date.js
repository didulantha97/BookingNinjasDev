import locale from '@salesforce/i18n/locale';

const dateOptions = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
};

const timeOptions = {
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric'
};

const isValid = function (date) {
    return date instanceof Date && !isNaN(date);
};

const format = function (date, options) {
    options = options || Object.assign({}, dateOptions, timeOptions);
    const formatter = new Intl.DateTimeFormat(locale, options);
    return isValid(date) ? formatter.format(date) : '';
};

const formatDate = function (date, options) {
    return format(date, options || dateOptions);
};

const isWeekend = function (date) {
    if (!isValid(date)) return false;
    const dayOfWeek = date.getDay();
    return dayOfWeek === 6 || dayOfWeek === 0;
};

const addDays = function (date, days) {
    if (!isValid(date)) return '';
    let n = new Date(date);
    n.setDate(n.getDate() + days);
    return n;
};

const nextMonth = function (date) {
    if (!isValid(date)) return date;
    return new Date(date.getFullYear(), date.getMonth() + 1, 1);
};

const prevMonth = function (date) {
    if (!isValid(date)) return date;
    return new Date(date.getFullYear(), date.getMonth() - 1, 1);
};

const fullNameMonth = function (date) {
    if (!isValid(date)) return date;
    return format(date, {month: 'long'});
};




Object.defineProperties(Date, {
    isValid: {
        value: isValid
    },
    format: {
        value: format
    },
    formatDate: {
        value: formatDate
    },
    isWeekend: {
        value: isWeekend
    },
    addDays: {
        value: addDays
    },
    nextMonth: {
        value: nextMonth
    },
    prevMonth: {
        value: prevMonth
    },
    fullNameMonth: {
        value: fullNameMonth
    }
});

// Object.defineProperties(Date.prototype, {
//     isValid: {
//         value: function () {
//             return Date.isValid(this);
//         }
//     },
//     format: {
//         value: function (options) {
//             return Date.format(this, options);
//         }
//     },
//     formatDate: {
//         value: function (options) {
//             return Date.formatDate(this, options);
//         }
//     },
//     isWeekend: {
//         value: function () {
//             return Date.isWeekend(this);
//         }
//     },
//     addDays: {
//         value: function (days) {
//             return Date.addDays(this, days);
//         }
//     }
// });


export default Date;