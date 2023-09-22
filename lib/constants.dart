const port = '1029';
const baseUrl = 'http://test.com:$port?id=';
const keyLength = 32;
const replacePattern = '#key#';

// the keyLength being divisible by the isolateCount lead to better work distribution in the current
// implementation
const isolateCount = keyLength;
