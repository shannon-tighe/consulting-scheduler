
// Shared utility methods for LWCs

/**
 * Extract record Id from a Lightning URL when not available via a public property (I.E. "New" on related lists)
 * @param {String} urlVal -  url to extract Id from
 * @param {String} objType - api name of the object that corresponds to the extracted Id
 * @returns 
 */
export function getRecordIdFromUrl(urlVal, objType) {
    if(!urlVal || !objType) return '';

    let splitter = '/r/' + objType + '/';
    let splitData = urlVal.split(splitter);

    if(splitData.length < 2 || splitData[1].length < 18) return '';
    return splitData[1].substring(0, 18);
}