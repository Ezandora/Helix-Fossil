
//Allows error checking. The intention behind this design is Errors are passed in to a method. The method then sets the error if anything went wrong.
record Error
{
	boolean was_error;
	string explanation;
};

Error ErrorMake(boolean was_error, string explanation)
{
	Error err;
	err.was_error = was_error;
	err.explanation = explanation;
	return err;
}

Error ErrorMake()
{
	return ErrorMake(false, "");
}

void ErrorSet(Error err, string explanation)
{
	err.was_error = true;
	err.explanation = explanation;
}

void ErrorSet(Error err)
{
	ErrorSet(err, "Unknown");
}

//Coordinate system is upper-left origin.

int INT32_MAX = 2147483647;



float clampf(float v, float min_value, float max_value)
{
	if (v > max_value)
		return max_value;
	if (v < min_value)
		return min_value;
	return v;
}

float clampNormalf(float v)
{
	return clampf(v, 0.0, 1.0);
}

int clampi(int v, int min_value, int max_value)
{
	if (v > max_value)
		return max_value;
	if (v < min_value)
		return min_value;
	return v;
}

float clampNormali(int v)
{
	return clampi(v, 0, 1);
}

//random() will halt the script if range is <= 1, which can happen when picking a random object out of a variable-sized list.
//There's also a hidden bug where values above 2147483647 will be treated as zero.
int random_safe(int range)
{
	if (range < 2 || range > 2147483647)
		return 0;
	return random(range);
}

float randomf()
{
    return random_safe(2147483647).to_float() / 2147483647.0;
}

//to_int will print a warning, but not halt, if you give it a non-int value.
//This function prevents the warning message.
//err is set if value is not an integer.
int to_int_silent(string value, Error err)
{
    //to_int() supports floating-point values. is_integer() will return false.
    //So manually strip out everything past the dot.
    //We probably should just ask for to_int() to be silent in the first place.
    int dot_position = value.index_of(".");
    if (dot_position != -1 && dot_position > 0) //two separate concepts - is it valid, and is it past the first position. I like testing against both, for safety against future changes.
    {
        value = value.substring(0, dot_position);
    }
    
	if (is_integer(value))
        return to_int(value);
    ErrorSet(err, "Unknown integer \"" + value + "\".");
	return 0;
}

int to_int_silent(string value)
{
	return to_int_silent(value, ErrorMake());
}

//Silly conversions in case we chose the wrong function, removing the need for a int -> string -> int hit.
int to_int_silent(int value)
{
    return value;
}

int to_int_silent(float value)
{
    return value;
}


float sqrt(float v, Error err)
{
    if (v < 0.0)
    {
        ErrorSet(err, "Cannot take square root of value " + v + " less than 0.0");
        return -1.0; //mathematically incorrect, but prevents halting. should return NaN
    }
	return square_root(v);
}

float sqrt(float v)
{
    return sqrt(v, ErrorMake());
}

float fabs(float v)
{
    if (v < 0.0)
        return -v;
    return v;
}

int abs(int v)
{
    if (v < 0)
        return -v;
    return v;
}

int ceiling(float v)
{
	return ceil(v);
}

int pow2i(int v)
{
	return v * v;
}

float pow2f(float v)
{
	return v * v;
}

//x^p
float powf(float x, float p)
{
    return x ** p;
}

//x^p
int powi(int x, int p)
{
    return x ** p;
}

record Vec2i
{
	int x; //or width
	int y; //or height
};

Vec2i Vec2iMake(int x, int y)
{
	Vec2i result;
	result.x = x;
	result.y = y;
	
	return result;
}

Vec2i Vec2iCopy(Vec2i v)
{
    return Vec2iMake(v.x, v.y);
}

Vec2i Vec2iZero()
{
	return Vec2iMake(0,0);
}

boolean Vec2iValueInInterval(Vec2i v, int value)
{
    if (value >= v.x && value <= v.y)
        return true;
    return false;
}

boolean Vec2iValueInRange(Vec2i v, int value)
{
	return Vec2iValueInInterval(v, value);
}

boolean Vec2iEquals(Vec2i a, Vec2i b)
{
    if (a.x != b.x) return false;
    if (a.y != b.y) return false;
    return true;
}

string Vec2iDescription(Vec2i v)
{
    buffer out;
    out.append("[");
    out.append(v.x);
    out.append(", ");
    out.append(v.y);
    out.append("]");
    return out.to_string();
}

Vec2i Vec2iIntersection(Vec2i a, Vec2i b)
{
    Vec2i result;
    result.x = max(a.x, b.x);
    result.y = min(a.y, b.y);
    return result;
}

boolean Vec2iIntersectsWithVec2i(Vec2i a, Vec2i b)
{
    //Assumed [min, max]:
    if (a.y < b.x) return false;
    if (a.x > b.y) return false;
    return true;
}

record Vec2f
{
	float x; //or width
	float y; //or height
};

Vec2f Vec2fMake(float x, float y)
{
	Vec2f result;
	result.x = x;
	result.y = y;
	
	return result;
}

Vec2f Vec2fCopy(Vec2f v)
{
    return Vec2fMake(v.x, v.y);
}

Vec2f Vec2fZero()
{
	return Vec2fMake(0.0, 0.0);
}

boolean Vec2fValueInRange(Vec2f v, float value)
{
    if (value >= v.x && value <= v.y)
        return true;
    return false;
}

Vec2f Vec2fMultiply(Vec2f v, float c)
{
	return Vec2fMake(v.x * c, v.y * c);
}
Vec2f Vec2fAdd(Vec2f v, float c)
{
    return Vec2fMake(v.x + c, v.y + c);
}
float Vec2fAverage(Vec2f v)
{
    return (v.x + v.y) * 0.5;
}



string Vec2fDescription(Vec2f v)
{
    buffer out;
    out.append("[");
    out.append(v.x);
    out.append(", ");
    out.append(v.y);
    out.append("]");
    return out.to_string();
}


record Rect
{
	Vec2i min_coordinate;
	Vec2i max_coordinate;
};

Rect RectMake(Vec2i min_coordinate, Vec2i max_coordinate)
{
	Rect result;
	result.min_coordinate = Vec2iCopy(min_coordinate);
	result.max_coordinate = Vec2iCopy(max_coordinate);
	return result;
}

Rect RectCopy(Rect r)
{
    return RectMake(r.min_coordinate, r.max_coordinate);
}

Rect RectMake(int min_x, int min_y, int max_x, int max_y)
{
	return RectMake(Vec2iMake(min_x, min_y), Vec2iMake(max_x, max_y));
}

Rect RectZero()
{
	return RectMake(Vec2iZero(), Vec2iZero());
}


void listAppend(Rect [int] list, Rect entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

//Allows for fractional digits, not just whole numbers. Useful for preventing "+233.333333333333333% item"-type output.
//Outputs 3.0, 3.1, 3.14, etc.
float round(float v, int additional_fractional_digits)
{
	if (additional_fractional_digits < 1)
		return v.round().to_float();
	float multiplier = powf(10.0, additional_fractional_digits);
	return to_float(round(v * multiplier)) / multiplier;
}

//Similar to round() addition above, but also converts whole float numbers into integers for output
string roundForOutput(float v, int additional_fractional_digits)
{
	v = round(v, additional_fractional_digits);
	int vi = v.to_int();
	if (vi.to_float() == v)
		return vi.to_string();
	else
		return v.to_string();
}


float floor(float v, int additional_fractional_digits)
{
	if (additional_fractional_digits < 1)
		return v.floor().to_float();
	float multiplier = powf(10.0, additional_fractional_digits);
	return to_float(floor(v * multiplier)) / multiplier;
}

string floorForOutput(float v, int additional_fractional_digits)
{
	v = floor(v, additional_fractional_digits);
	int vi = v.to_int();
	if (vi.to_float() == v)
		return vi.to_string();
	else
		return v.to_string();
}


float TriangularDistributionCalculateCDF(float x, float min, float max, float centre)
{
    //piecewise function:
    if (x < min) return 0.0;
    else if (x > max) return 1.0;
    else if (x >= min && x <= centre)
    {
        float divisor = (max - min) * (centre - min);
        if (divisor == 0.0)
            return 0.0;
        
        return pow2f(x - min) / divisor;
    }
    else if (x <= max && x > centre)
    {
        float divisor = (max - min) * (max - centre);
        if (divisor == 0.0)
            return 0.0;
        
            
        return 1.0 - pow2f(max - x) / divisor;
    }
    else //probably only happens with weird floating point values, assume chance of zero:
        return 0.0;
}

//assume a centre equidistant from min and max
float TriangularDistributionCalculateCDF(float x, float min, float max)
{
    return TriangularDistributionCalculateCDF(x, min, max, (min + max) * 0.5);
}

float averagef(float a, float b)
{
    return (a + b) * 0.5;
}

boolean numberIsInRangeInclusive(int v, int min, int max)
{
    if (v < min) return false;
    if (v > max) return false;
    return true;
}
//WARNING: All listAppend functions are flawed.
//Specifically, there's a possibility of a hole that causes order to be incorrect.
//But, the only way to fix that is to traverse the list to determine the maximum key.
//That would take forever...

string listLastObject(string [int] list)
{
    if (list.count() == 0)
        return "";
    return list[list.count() - 1];
}

void listAppend(string [int] list, string entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(string [int] list, string [int] entries)
{
	foreach key in entries
		list.listAppend(entries[key]);
}

string [int] listUnion(string [int] list, string [int] list2)
{
    string [int] result;
    foreach key, s in list
        result.listAppend(s);
    foreach key, s in list2
        result.listAppend(s);
    return result;
}

void listAppendList(boolean [item] destination, boolean [item] source)
{
    foreach it, value in source
        destination[it] = value;
}

void listAppendList(boolean [string] destination, boolean [string] source)
{
    foreach key, value in source
        destination[key] = value;
}

void listAppendList(boolean [skill] destination, boolean [skill] source)
{
    foreach key, value in source
        destination[key] = value;
}

void listAppend(item [int] list, item entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(item [int] list, item [int] entries)
{
	foreach key in entries
        list.listAppend(entries[key]);
}



void listAppend(int [int] list, int entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(float [int] list, float entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(location [int] list, location entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(element [int] list, element entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(location [int] list, location [int] entries)
{
	foreach key in entries
        list.listAppend(entries[key]);
}

void listAppend(effect [int] list, effect entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(skill [int] list, skill entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(familiar [int] list, familiar entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(monster [int] list, monster entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(phylum [int] list, phylum entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(buffer [int] list, buffer entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(slot [int] list, slot entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(thrall [int] list, thrall entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}





void listAppend(string [int][int] list, string [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(skill [int][int] list, skill [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(familiar [int][int] list, familiar [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(int [int][int] list, int [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(item [int][int] list, item [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(skill [int] list, boolean [skill] entry)
{
    foreach v in entry
        list.listAppend(v);
}

void listAppend(item [int] list, boolean [item] entry)
{
    foreach v in entry
        list.listAppend(v);
}

void listPrepend(string [int] list, string entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

void listPrepend(skill [int] list, skill entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

void listAppendList(skill [int] list, skill [int] entries)
{
	foreach key in entries
        list.listAppend(entries[key]);
}

void listPrepend(location [int] list, location entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

void listPrepend(item [int] list, item entry)
{
    int position = 0;
    while (list contains position)
        position -= 1;
    list[position] = entry;
}


void listClear(string [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(int [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(item [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(location [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(monster [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(skill [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}


void listClear(boolean [string] list)
{
	foreach i in list
	{
		remove list[i];
	}
}


string [int] listMakeBlankString()
{
	string [int] result;
	return result;
}

item [int] listMakeBlankItem()
{
	item [int] result;
	return result;
}

skill [int] listMakeBlankSkill()
{
	skill [int] result;
	return result;
}

location [int] listMakeBlankLocation()
{
	location [int] result;
	return result;
}

monster [int] listMakeBlankMonster()
{
	monster [int] result;
	return result;
}

familiar [int] listMakeBlankFamiliar()
{
	familiar [int] result;
	return result;
}

int [int] listMakeBlankInt()
{
    int [int] result;
    return result;
}




string [int] listMake(string e1)
{
	string [int] result;
	result.listAppend(e1);
	return result;
}

string [int] listMake(string e1, string e2)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

string [int] listMake(string e1, string e2, string e3)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

string [int] listMake(string e1, string e2, string e3, string e4)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

string [int] listMake(string e1, string e2, string e3, string e4, string e5)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

string [int] listMake(string e1, string e2, string e3, string e4, string e5, string e6)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	result.listAppend(e6);
	return result;
}

int [int] listMake(int e1)
{
	int [int] result;
	result.listAppend(e1);
	return result;
}

int [int] listMake(int e1, int e2)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

int [int] listMake(int e1, int e2, int e3)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

int [int] listMake(int e1, int e2, int e3, int e4)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

int [int] listMake(int e1, int e2, int e3, int e4, int e5)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

item [int] listMake(item e1)
{
	item [int] result;
	result.listAppend(e1);
	return result;
}

item [int] listMake(item e1, item e2)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

item [int] listMake(item e1, item e2, item e3)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

item [int] listMake(item e1, item e2, item e3, item e4)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

item [int] listMake(item e1, item e2, item e3, item e4, item e5)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

skill [int] listMake(skill e1)
{
	skill [int] result;
	result.listAppend(e1);
	return result;
}

skill [int] listMake(skill e1, skill e2)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

skill [int] listMake(skill e1, skill e2, skill e3)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

skill [int] listMake(skill e1, skill e2, skill e3, skill e4)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

skill [int] listMake(skill e1, skill e2, skill e3, skill e4, skill e5)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}


monster [int] listMake(monster e1)
{
	monster [int] result;
	result.listAppend(e1);
	return result;
}

monster [int] listMake(monster e1, monster e2)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3, monster e4)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3, monster e4, monster e5)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3, monster e4, monster e5, monster e6)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	result.listAppend(e6);
	return result;
}

string listJoinComponents(string [int] list, string joining_string, string and_string)
{
	buffer result;
	boolean first = true;
	int number_seen = 0;
	foreach i, value in list
	{
		if (first)
		{
			result.append(value);
			first = false;
		}
		else
		{
			if (!(list.count() == 2 && and_string != ""))
				result.append(joining_string);
			if (and_string != "" && number_seen == list.count() - 1)
			{
				result.append(" ");
				result.append(and_string);
				result.append(" ");
			}
			result.append(value);
		}
		number_seen = number_seen + 1;
	}
	return result.to_string();
}

string listJoinComponents(string [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(item [int] list, string joining_string, string and_string)
{
	//lazy:
	//convert items to strings, join that
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(item [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(monster [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}
string listJoinComponents(monster [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(effect [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(effect [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}


string listJoinComponents(familiar [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(familiar [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}



string listJoinComponents(location [int] list, string joining_string, string and_string)
{
	//lazy:
	//convert locations to strings, join that
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(location [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(phylum [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(phylum [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}



string listJoinComponents(skill [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(skill [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(int [int] list, string joining_string, string and_string)
{
	//lazy:
	//convert ints to strings, join that
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(int [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}


void listRemoveKeys(string [int] list, int [int] keys_to_remove)
{
	foreach i in keys_to_remove
	{
		int key = keys_to_remove[i];
		if (!(list contains key))
			continue;
		remove list[key];
	}
}

int listSum(int [int] list)
{
    int v = 0;
    foreach key in list
    {
        v += list[key];
    }
    return v;
}


string [int] listCopy(string [int] l)
{
    string [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

int [int] listCopy(int [int] l)
{
    int [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

item [int] listCopy(item [int] l)
{
    item [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}


monster [int] listCopy(monster [int] l)
{
    monster [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

element [int] listCopy(element [int] l)
{
    element [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

skill [int] listCopy(skill [int] l)
{
    skill [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

boolean [monster] listCopy(boolean [monster] l)
{
    boolean [monster] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

int [item] listCopy(int [item] l)
{
    int [item] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

//Strict, in this case, means the keys start at 0, and go up by one per entry. This allows easy consistent access
boolean listKeysMeetStrictRequirements(string [int] list)
{
    int expected_value = 0;
    foreach key in list
    {
        if (key != expected_value)
            return false;
        expected_value += 1;
    }
    return true;
}
string [int] listCopyStrictRequirements(string [int] list)
{
    string [int] result;
    foreach key in list
        result.listAppend(list[key]);
    return result;
}

string [string] mapMake()
{
	string [string] result;
	return result;
}

string [string] mapMake(string key1, string value1)
{
	string [string] result;
	result[key1] = value1;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3, string key4, string value4)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	result[key4] = value4;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3, string key4, string value4, string key5, string value5)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	result[key4] = value4;
	result[key5] = value5;
	return result;
}


string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3, string key4, string value4, string key5, string value5, string key6, string value6)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	result[key4] = value4;
	result[key5] = value5;
	result[key6] = value6;
	return result;
}

string [string] mapCopy(string [string] map)
{
    string [string] result;
    foreach key in map
        result[key] = map[key];
    return result;
}

boolean mapsAreEqual(string [string] map1, string [string] map2)
{
	if (map1.count() != map2.count())
	{
        //print_html("map1.c = " + map1.count() + " which is not " + map2.count());
		return false;
    }
	foreach key1, v in map1
	{
		if (!(map2 contains key1))
        {
        	//print_html("map2 lacks " + key1);
        	return false;
        }
        if (map2[key1] != v)
        {
            //print_html("map2 v(" + map2[key1] + " does not equal " + key1 + " (" + v + ")");
        	return false;
        }
	}
	return true;
}

boolean [string] listInvert(string [int] list)
{
	boolean [string] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}


boolean [int] listInvert(int [int] list)
{
	boolean [int] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [location] listInvert(location [int] list)
{
	boolean [location] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [item] listInvert(item [int] list)
{
	boolean [item] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [monster] listInvert(monster [int] list)
{
	boolean [monster] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [familiar] listInvert(familiar [int] list)
{
	boolean [familiar] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

int [int] listConvertToInt(string [int] list)
{
	int [int] result;
	foreach key in list
		result[key] = list[key].to_int();
	return result;
}

item [int] listConvertToItem(string [int] list)
{
	item [int] result;
	foreach key in list
		result[key] = list[key].to_item();
	return result;
}

string listFirstObject(string [int] list)
{
    foreach key in list
        return list[key];
    return "";
}

//(I'm assuming maps have a consistent enumeration order, which may not be the case)
int listKeyForIndex(string [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(location [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(familiar [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(item [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(monster [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(int [int] list, int index)
{
    int i = 0;
    foreach key in list
    {
        if (i == index)
            return key;
        i += 1;
    }
    return -1;
}

int llistKeyForIndex(string [int][int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

string listGetRandomObject(string [int] list)
{
    if (list.count() == 0)
        return "";
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

item listGetRandomObject(item [int] list)
{
    if (list.count() == 0)
        return $item[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

location listGetRandomObject(location [int] list)
{
    if (list.count() == 0)
        return $location[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

familiar listGetRandomObject(familiar [int] list)
{
    if (list.count() == 0)
        return $familiar[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

monster listGetRandomObject(monster [int] list)
{
    if (list.count() == 0)
        return $monster[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

int listGetRandomObject(int [int] list)
{
    if (list.count() == 0)
        return -1;
    if (list.count() == 1)
        return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}


boolean listContainsValue(monster [int] list, monster vo)
{
    foreach key, v2 in list
    {
        if (v2 == vo)
            return true;
    }
    return false;
}

string [int] listInvert(boolean [string] list)
{
    string [int] out;
    foreach m, value in list
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

int [int] listInvert(boolean [int] list)
{
    int [int] out;
    foreach m, value in list
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

skill [int] listInvert(boolean [skill] list)
{
    skill [int] out;
    foreach m, value in list
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

monster [int] listInvert(boolean [monster] monsters)
{
    monster [int] out;
    foreach m, value in monsters
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

location [int] listInvert(boolean [location] list)
{
    location [int] out;
    foreach k, value in list
    {
        if (value)
            out.listAppend(k);
    }
    return out;
}

familiar [int] listInvert(boolean [familiar] list)
{
    familiar [int] out;
    foreach k, value in list
    {
        if (value)
            out.listAppend(k);
    }
    return out;
}

item [int] listInvert(boolean [item] list)
{
    item [int] out;
    foreach k, value in list
    {
        if (value)
            out.listAppend(k);
    }
    return out;
}

skill [int] listConvertStringsToSkills(string [int] list)
{
    skill [int] out;
    foreach key, s in list
    {
        out.listAppend(s.to_skill());
    }
    return out;
}

monster [int] listConvertStringsToMonsters(string [int] list)
{
    monster [int] out;
    foreach key, s in list
    {
        out.listAppend(s.to_monster());
    }
    return out;
}

int [int] stringToIntIntList(string input, string delimiter)
{
	int [int] out;
	if (input == "")
		return out;
	foreach key, v in input.split_string(delimiter)
	{
		if (v == "") continue;
		out.listAppend(v.to_int());
	}
	return out;
}

int [int] stringToIntIntList(string input)
{
	return stringToIntIntList(input, ",");
}

boolean [location] locationToLocationMap(location l)
{
	boolean [location] map;
	map[l] = true;
	return map;
}



//now built-in:
/*buffer to_buffer(string str)
{
	buffer result;
	result.append(str);
	return result;
}*/

buffer copyBuffer(buffer buf)
{
    buffer result;
    result.append(buf);
    return result;
}

//split_string returns an immutable array, which will error on certain edits
//Use this function - it converts to an editable map.
string [int] split_string_mutable(string source, string delimiter)
{
	string [int] result;
	string [int] immutable_array = split_string(source, delimiter);
	foreach key in immutable_array
		result[key] = immutable_array[key];
	return result;
}

//This returns [] for empty strings. This isn't standard for split(), but is more useful for passing around lists. Hacky, I suppose.
string [int] split_string_alternate(string source, string delimiter)
{
    if (source.length() == 0)
        return listMakeBlankString();
    return split_string_mutable(source, delimiter);
}
string [int] split_string_alternate_immutable(string source, string delimiter)
{
    if (source.length() == 0)
        return listMakeBlankString();
    return split_string(source, delimiter);
}

string slot_to_string(slot s)
{
    if (s == $slot[acc1] || s == $slot[acc2] || s == $slot[acc3])
        return "accessory";
    else if (s == $slot[sticker1] || s == $slot[sticker2] || s == $slot[sticker3])
        return "sticker";
    else if (s == $slot[folder1] || s == $slot[folder2] || s == $slot[folder3] || s == $slot[folder4] || s == $slot[folder5])
        return "folder";
    else if (s == $slot[fakehand])
        return "fake hand";
    else if (s == $slot[crown-of-thrones])
        return "crown of thrones";
    else if (s == $slot[buddy-bjorn])
        return "buddy bjorn";
    return s;
}

string slot_to_plural_string(slot s)
{
    if (s == $slot[acc1] || s == $slot[acc2] || s == $slot[acc3])
        return "accessories";
    else if (s == $slot[hat])
        return "hats";
    else if (s == $slot[weapon])
        return "weapons";
    else if (s == $slot[off-hand])
        return "off-hands";
    else if (s == $slot[shirt])
        return "shirts";
    else if (s == $slot[back])
        return "back items";
    
    return s.slot_to_string();
}

string format_today_to_string(string desired_format)
{
    return format_date_time("yyyyMMdd", today_to_string(), desired_format);
    //We tried this, and instead at 7:51AM local time, it claimed the day was yesterday. I don't get it either.
    //return format_date_time("yyyyMMdd hh:mm:ss z", today_to_string() + " " + time_to_string(), desired_format);
}
//this messes with your timezone, because why wouldn't it?
string format_intraday_time_to_string(string desired_format)
{
    //return format_date_time("hh:mm:ss z", time_to_string(), desired_format);
    return format_date_time("hh:mm:ss", time_to_string(), desired_format); //omit time zone, because give it a time zone and suddenly it decides to be Difficult.
}


string [int] __int_to_wordy_map;
string int_to_wordy(int v) //Not complete, only supports a handful:
{
    if (__int_to_wordy_map.count() == 0)
    {
        __int_to_wordy_map = split_string("zero,one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen,twenty,twenty-one,twenty-two,twenty-three,twenty-four,twenty-five,twenty-six,twenty-seven,twenty-eight,twenty-nine,thirty,thirty-one", ",");
    }
    if (__int_to_wordy_map contains v)
        return __int_to_wordy_map[v];
    return v.to_string();
}


boolean stringHasPrefix(string s, string prefix)
{
	if (s.length() < prefix.length())
		return false;
	else if (s.length() == prefix.length())
		return (s == prefix);
	else if (substring(s, 0, prefix.length()) == prefix)
		return true;
	return false;
}

boolean stringHasSuffix(string s, string suffix)
{
	if (s.length() < suffix.length())
		return false;
	else if (s.length() == suffix.length())
		return (s == suffix);
	else if (substring(s, s.length() - suffix.length()) == suffix)
		return true;
	return false;
}

string capitaliseFirstLetter(string v)
{
	buffer buf = v.to_buffer();
	if (v.length() <= 0)
		return v;
	buf.replace(0, 1, buf.char_at(0).to_upper_case());
	return buf.to_string();
}

//shadowing; this may override ints
string pluralise(float value, string non_plural, string plural)
{
	string value_out = "";
	if (value.to_int() == value)
		value_out = value.to_int();
    else
    	value_out = value;
	if (value == 1.0)
		return value_out + " " + non_plural;
	else
		return value_out + " " + plural;
}

string pluralise(int value, string non_plural, string plural)
{
	if (value == 1)
		return value + " " + non_plural;
	else
		return value + " " + plural;
}

string pluralise(int value, item i)
{
	return pluralise(value, i.to_string(), i.plural);
}

string pluralise(item i) //whatever we have around
{
	return pluralise(i.available_amount(), i);
}

string pluralise(effect e)
{
    return pluralise(e.have_effect(), "turn", "turns") + " of " + e;
}

string pluraliseWordy(int value, string non_plural, string plural)
{
	if (value == 1)
    {
        if (non_plural == "more time") //we're gonna celebrate
            return "One More Time";
        else if (non_plural == "more turn")
            return "One More Turn";
		return value.int_to_wordy() + " " + non_plural;
    }
	else
		return value.int_to_wordy() + " " + plural;
}

string pluraliseWordy(int value, item i)
{
	return pluraliseWordy(value, i.to_string(), i.plural);
}

string pluraliseWordy(item i) //whatever we have around
{
	return pluraliseWordy(i.available_amount(), i);
}


//Additions to standard API:
//Auto-conversion property functions:
boolean get_property_boolean(string property)
{
	return get_property(property).to_boolean();
}

int get_property_int(string property)
{
	return get_property(property).to_int_silent();
}

location get_property_location(string property)
{
	return get_property(property).to_location();
}

float get_property_float(string property)
{
	return get_property(property).to_float();
}

monster get_property_monster(string property)
{
	return get_property(property).to_monster();
}

//Returns true if the propery is equal to my_ascensions(). Commonly used in mafia properties.
boolean get_property_ascension(string property)
{
    return get_property_int(property) == my_ascensions();
}

element get_property_element(string property)
{
    return get_property(property).to_element();
}

item get_property_item(string property)
{
    return get_property(property).to_item();
}


/*
Discovery - get_ingredients() takes up to 5.8ms per call, scaling to inventory size. Fixing the code in mafia might be possible, but it's old and looks complicated.
This implementation is not 1:1 compatible, as it doesn't take into account your current status, but we don't generally need that information(?).
*/

//Relevant prototype:
//int [item] get_ingredients_fast(item it)


Record Recipe
{
	item creating_item;
	string type;
	int [item] source_items;
	
	Coinmaster source_coinmaster;
	
	string coinmaster_row_id;
};

static
{
	Recipe [item][int] __item_recipes;
	
    boolean [item] __item_is_purchasable_from_a_store;
    boolean [item] __items_that_craft_food;
}

Recipe [int] recipes_for_item(item it)
{
	return __item_recipes[it];
}

Recipe recipe_for_item(item it)
{
	if (__item_recipes[it].count() == 0)
	{
		Recipe blank;
        return blank;
	}
	return __item_recipes[it][0];
}

int [item] get_ingredients_fast(item it)
{
	Recipe [int] recipes = __item_recipes[it];
	if (recipes.count() == 0)
	{
		//use get_ingredient?
        //mafia appears to have various items that return get_ingredients but do not show up in the datafiles
        int [item] mafia_response = it.get_ingredients();
        return mafia_response;
	}
	return recipes[0].source_items;
}

boolean item_is_purchasable_from_a_store(item it)
{
    return __item_is_purchasable_from_a_store[it];
}

boolean item_cannot_be_asdon_martined_because_it_was_purchased_from_a_store(item it)
{
	if ($items[wasabi pocky,tobiko pocky,natto pocky,wasabi-infused sake,tobiko-infused sake,natto-infused sake] contains it) return false;
	return it.item_is_purchasable_from_a_store();
}



//Initialisation code, ignore:
boolean parseDatafileItem(int [item] out, string item_name)
{
    if (item_name == "") return false;
    
    item it = item_name.to_item();
    if (it != $item[none])
    {
        out[it] += 1;
    }
    else if (item_name.contains_text("("))
    {
        //Do complicated parsing.
        //NOTE: "CRIMBCO Employee Handbook (chapter 1)" and "snow berries (7)" are both valid entries that mean different things.
        //optional space between the item name and parenthesis because the CRIMBO12 items (BittyCar MeatCar) have no space there
        string [int][int] matches = item_name.group_string("(.*?)[ ]*\\(([0-9]*)\\)");
        if (matches[0].count() == 3)
        {
            it = matches[0][1].to_item();
            if (it == $item[none]) return false;
            int amount = matches[0][2].to_int();
            if (amount > 0)
            {
                out[it] += amount;
            }
            else
            	return false;
        }
    }
    return true;
}


void InternalAddRecipe(Recipe r)
{
	if (!(__item_recipes contains r.creating_item))
	{
		Recipe [int] blank;
        __item_recipes[r.creating_item] = blank;
	}
	__item_recipes[r.creating_item][__item_recipes[r.creating_item].count()] = r;
	if (r.type == "COOK" || r.type == "COOK_FANCY")
    {
    	foreach it in r.source_items
        	__items_that_craft_food[it] = true;
    }
}

void InternalParseConcoctionEntry(string entry)
{
	string [int] split_entry = entry.split_string_alternate_immutable("\t");
	//crafting_thing, crafting_type, mixing_item_1, mixing_item_2, mixing_item_3, mixing_item_4, mixing_item_5, mixing_item_6, mixing_item_7, mixing_item_8, mixing_item_9, mixing_item_10, mixing_item_11, mixing_item_12, mixing_item_13, mixing_item_14, mixing_item_15, mixing_item_16, mixing_item_17, mixing_item_18
	if (split_entry.count() < 3) return;
	Recipe r;
	
	r.creating_item = split_entry[0].to_item();
	r.type = split_entry[1];
	if (r.creating_item == $item[none])
	{
		//print_html("Unknown item " + split_entry[0]);
        return;
	}
	for i from 2 to split_entry.count() - 1
	{
		string value = split_entry[i];
		int [item] out;
        parseDatafileItem(out, value);
        if (out.count() > 0)
        {
        	foreach it, amount in out
            {
            	r.source_items[it] += amount;
            }
        }
	}
    if (r.type.contains_text("ROW"))
        __item_is_purchasable_from_a_store[r.creating_item] = true;
	
	if (r.source_items.count() == 0)
	{
		//print_html(r.creating_item + " has no source items, entry is \"" + entry + "\"");
        return;
	}
	InternalAddRecipe(r);
	
	
	//print_html("Added " + r.creating_item + " of type " + r.type + " which requires " + r.source_items.to_json());
}

void InternalParseConcoctions()
{
	string [int] file_lines = file_to_array("data/concoctions.txt");
	foreach key, entry in file_lines
	{
		//Note that FileUtilities.java appears to only ignore lines starting exactly with #.
        //So that is what we will do.
        if (entry == "") continue;
        if (entry.char_at(0) == "#") continue;
        InternalParseConcoctionEntry(entry);
	}
	
	if (false)
	{
		foreach it in __item_recipes
        {
        	if (__item_recipes[it].count() <= 1) continue;
            print_html(it + " has " + __item_recipes[it].count() + " recipes: " + __item_recipes[it].to_json()); 
        }
	}
}

void InternalParseCoinmasterEntry(string entry)
{
	//shop name, buy or sell, currency amount, item acquired, row
	
	string [int] split_entry = entry.split_string_alternate_immutable("\t");
	if (split_entry.count() < 4) return;
	if (split_entry[1] != "buy") return;
	
	Recipe r;
	r.source_coinmaster = split_entry[0].to_coinmaster();
	if (r.source_coinmaster == $coinmaster[none])
	{
		//print_html("Unknown coinmaster for " + entry);
        return;
	}
	r.creating_item = split_entry[3].to_item();
	if (r.creating_item == $item[none])
	{
		//print_html("Unknown item for " + entry);
        return;
	}
	
	int currency_amount = split_entry[2].to_int();
	item store_item = r.source_coinmaster.item;
	
	if (store_item != $item[none])
		r.source_items[store_item] = currency_amount;
	
	__item_is_purchasable_from_a_store[r.creating_item] = true;
	
	if (split_entry.count() >= 5)
		r.coinmaster_row_id = split_entry[4];
	if (r.source_items.count() == 0)
	{
		//print_html(r.creating_item + " has no source items, entry is \"" + entry + "\"");
        return;
	}
	InternalAddRecipe(r);
	//print_html(r.creating_item + ": " + r.to_json());
}

void InternalParseCoinmasters()
{
	//coinmasters.txt has improper format for actual game; it assumes a "store" currency which is not accurate, stores can have multiple currencies
	
	string [int] file_lines = file_to_array("data/coinmasters.txt");
	foreach key, entry in file_lines
	{
        if (entry == "") continue;
        if (entry.char_at(0) == "#") continue;
        InternalParseCoinmasterEntry(entry);
	}
}


void initialiseItemIngredients()
{
    if (__item_recipes.count() > 0) return;
    
    //Parse concoctions:
    InternalParseConcoctions();
    
    //Parse coinmasters:
    InternalParseCoinmasters();
    
}
initialiseItemIngredients();





void testItemIngredients()
{
    print_html(__item_recipes.count() + " recipes known.");
    foreach it in $items[]
    {
        int [item] ground_truth_ingredients = it.get_ingredients();
        int [item] our_ingredients = get_ingredients_fast(it);
        if (ground_truth_ingredients.count() == 0 && our_ingredients.count() == 0) continue;
        
        boolean passes = true;
        if (ground_truth_ingredients.count() != our_ingredients.count())
        {
            passes = false;
            if (ground_truth_ingredients.count() == 0 && our_ingredients.count() > 0) //probably just a coinmaster
                continue;
        }
        else
        {
            foreach it2, amount in ground_truth_ingredients
            {
                if (our_ingredients[it2] != amount)
                {
                    passes = false;
                    break;
                }
            }
        }
        if (!passes)
        {
            print_html(it + ": " + ground_truth_ingredients.to_json() + " vs " + our_ingredients.to_json());
        }
    }
}

/*void main()
{
    testItemIngredients();
}*/



static
{
    int PATH_UNKNOWN = -1;
    int PATH_NONE = 0;
    int PATH_BOOZETAFARIAN = 1;
    int PATH_TEETOTALER = 2;
    int PATH_OXYGENARIAN = 3;

    int PATH_BEES_HATE_YOU = 4;
    int PATH_WAY_OF_THE_SURPRISING_FIST = 6;
    int PATH_TRENDY = 7;
    int PATH_AVATAR_OF_BORIS = 8;
    int PATH_BUGBEAR_INVASION = 9;
    int PATH_ZOMBIE_SLAYER = 10;
    int PATH_CLASS_ACT = 11;
    int PATH_AVATAR_OF_JARLSBERG = 12;
    int PATH_BIG = 14;
    int PATH_KOLHS = 15;
    int PATH_CLASS_ACT_2 = 16;
    int PATH_AVATAR_OF_SNEAKY_PETE = 17;
    int PATH_SLOW_AND_STEADY = 18;
    int PATH_HEAVY_RAINS = 19;
    int PATH_PICKY = 21;
    int PATH_STANDARD = 22;
    int PATH_ACTUALLY_ED_THE_UNDYING = 23;
    int PATH_ONE_CRAZY_RANDOM_SUMMER = 24;
    int PATH_COMMUNITY_SERVICE = 25;
    int PATH_AVATAR_OF_WEST_OF_LOATHING = 26;
    int PATH_THE_SOURCE = 27;
    int PATH_NUCLEAR_AUTUMN = 28;
    int PATH_GELATINOUS_NOOB = 29;
    int PATH_LICENSE_TO_ADVENTURE = 30;
    int PATH_LIVE_ASCEND_REPEAT = 31;
    int PATH_POCKET_FAMILIARS = 32;
    int PATH_G_LOVER = 33;
    int PATH_DISGUISES_DELIMIT = 34;
    int PATH_DEMIGUISE = 34;
    int PATH_DARK_GYFFTE = 35;
    int PATH_DARK_GIFT = 35;
    int PATH_VAMPIRE = 35;
    int PATH_2CRS = 36;
    int PATH_KINGDOM_OF_EXPLOATHING = 37;
    int PATH_EXPLOSION = 37;
    int PATH_EXPLOSIONS = 37;
    int PATH_EXPLODING = 37;
    int PATH_EXPLODED = 37;
    int PATH_OF_THE_PLUMBER = 38;
    int PATH_PLUMBER = 38;
    int PATH_LUIGI = 38;
    int PATH_MARIO = 38;
    int PATH_LOW_KEY_SUMMER = 39;
    int PATH_LOKI = 39;
    int PATH_GREY_GOO = 40;
    int PATH_ROBOT = 41;
    int PATH_QUANTUM_TERRARIUM = 42;
    int PATH_QUANTUM = 42;
    int PATH_WILDFIRE = 43;
    //missing paths here
    int PATH_SHRUNKEN_ADVENTURER = 49;
    int PATH_SMALL = 49;
}

float numeric_modifier_replacement(item it, string modifier_name)
{
    string modifier_lowercase = modifier_name.to_lower_case();
    float additional = 0;
    if (my_path().id == PATH_G_LOVER && !it.contains_text("g") && !it.contains_text("G"))
    	return 0.0;
    if (it == $item[your cowboy boots])
    {
        if (modifier_lowercase == "monster level" && $slot[bootskin].equipped_item() == $item[diamondback skin])
        {
            return 20.0;
        }
        if (modifier_lowercase == "initiative" && $slot[bootspur].equipped_item() == $item[quicksilver spurs])
            return 30;
        if (modifier_lowercase == "item drop" && $slot[bootspur].equipped_item() == $item[nicksilver spurs])
            return 30;
        if (modifier_lowercase == "muscle percent" && $slot[bootskin].equipped_item() == $item[grizzled bearskin])
            return 50.0;
        if (modifier_lowercase == "mysticality percent" && $slot[bootskin].equipped_item() == $item[frontwinder skin])
            return 50.0;
        if (modifier_lowercase == "moxie percent" && $slot[bootskin].equipped_item() == $item[mountain lion skin])
            return 50.0;
        //FIXME deal with rest (resistance, etc)
    }
    //so, when we don't have the smithsness items equipped, they have a numeric modifier of zero.
    //but, they always have an inherent value of five. so give them that.
    //FIXME do other smithsness items
    if (it == $item[a light that never goes out] && modifier_lowercase == "item drop")
    {
    	if (it.equipped_amount() == 0)
     	   additional += 5;
    }
    if (it == $item[backup camera])
    {
    	string camera_mode = get_property("backupCameraMode");
        if (modifier_lowercase == "monster level" && camera_mode == "ml")
        {
        	return clampi(my_level() * 3, 3, 50);
        }
        else if (modifier_lowercase == "meat drop" && camera_mode == "meat")
        	return 50;
        else if (modifier_lowercase == "initiative" && camera_mode == "init")
        	return 100;
    }
    return numeric_modifier(it, modifier_name) + additional;
}


static
{
    skill [class][int] __skills_by_class;
    
    void initialiseSkillsByClass()
    {
        if (__skills_by_class.count() > 0) return;
        foreach s in $skills[]
        {
            if (s.class != $class[none])
            {
                if (!(__skills_by_class contains s.class))
                {
                    skill [int] blank;
                    __skills_by_class[s.class] = blank;
                }
                __skills_by_class[s.class].listAppend(s);
            }
        }
    }
    initialiseSkillsByClass();
}


static
{
    boolean [skill] __libram_skills;
    
    void initialiseLibramSkills()
    {
        foreach s in $skills[]
        {
            if (s.libram)
                __libram_skills[s] = true;
        }
    }
    initialiseLibramSkills();
}


static
{
    boolean [item] __minus_combat_equipment;
    boolean [item] __equipment;
    boolean [item] __items_in_outfits;
    boolean [string][item] __equipment_by_numeric_modifier;
    void initialiseItems()
    {
    	int maximum_item_id = 0;
        foreach it in $items[]
        {
            //Crafting:
            //moved to ingredients.ash:
            /*string craft_type = it.craft_type();
            if (craft_type.contains_text("Cooking"))
            {
                foreach ingredient in it.get_ingredients_fast()
                {
                    __items_that_craft_food[ingredient] = true;
                }
            }*/
            maximum_item_id = MAX(maximum_item_id, it.to_int());
            //Equipment:
            if ($slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3,familiar] contains it.to_slot())
            {
                __equipment[it] = true;
                if (it.numeric_modifier("combat rate") < 0)
                    __minus_combat_equipment[it] = true;
            }
        }
        //mafia does not add new items to $items, so, support some new items:
        for i from maximum_item_id + 1 to maximum_item_id + 100
        {
        	item it = i.to_item();
            if (it == $item[none])
            {
            	continue;
            }
            
            if ($slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3,familiar] contains it.to_slot())
            {
                __equipment[it] = true;
                if (it.numeric_modifier("combat rate") < 0)
                    __minus_combat_equipment[it] = true;
            }
        }
        foreach key, outfit_name in all_normal_outfits()
        {
            foreach key, it in outfit_pieces(outfit_name)
                __items_in_outfits[it] = true;
        }
    }
    initialiseItems();
}

boolean [item] equipmentWithNumericModifier(string modifier_name)
{
	modifier_name = modifier_name.to_lower_case();
	//dynamic items here
    boolean [item] dynamic_items;
    dynamic_items[to_item("backup camera")] = true;
    dynamic_items[to_item("unwrapped knock-off retro superhero cape")] = true;
    dynamic_items[$item[kremlin's greatest briefcase]] = true;
    dynamic_items[$item[your cowboy boots]] = true;
    dynamic_items[$item[a light that never goes out]] = true; //FIXME all smithsness items
    if (!(__equipment_by_numeric_modifier contains modifier_name))
    {
        //Build it:
        boolean [item] blank;
        __equipment_by_numeric_modifier[modifier_name] = blank;
        foreach it in __equipment
        {
            if (dynamic_items contains it) continue;
            if (it.numeric_modifier(modifier_name) != 0.0)
                __equipment_by_numeric_modifier[modifier_name][it] = true;
        }
    }
    //Certain equipment is dynamic. Inspect them dynamically:
    boolean [item] extra_results;
    foreach it in dynamic_items
    {
        if (it.numeric_modifier_replacement(modifier_name) != 0.0)
        {
            extra_results[it] = true;
        }
    }
    //damage + spell damage is basically the same for most things
    string secondary_modifier = "";
    foreach e in $elements[hot,cold,spooky,stench,sleaze]
    {
        if (modifier_name == e + " damage")
            secondary_modifier = e + " spell damage";
    }
    if (secondary_modifier != "")
    {
    	foreach it in equipmentWithNumericModifier(secondary_modifier)
        	extra_results[it] = true;
    }
    
    if (extra_results.count() == 0)
        return __equipment_by_numeric_modifier[modifier_name];
    else
    {
        //Add extras:
        foreach it in __equipment_by_numeric_modifier[modifier_name]
        {
            extra_results[it] = true;
        }
        return extra_results;
    }
}

static
{
    boolean [item] __beancannon_source_items = $items[Heimz Fortified Kidney Beans,Hellfire Spicy Beans,Mixed Garbanzos and Chickpeas,Pork 'n' Pork 'n' Pork 'n' Beans,Shrub's Premium Baked Beans,Tesla's Electroplated Beans,Frigid Northern Beans,Trader Olaf's Exotic Stinkbeans,World's Blackest-Eyed Peas];
}

static
{
    //This would be a good mafia proxy value. Feature request?
    boolean [skill] __combat_skills_that_are_spells;
    void initialiseCombatSkillsThatAreSpells()
    {
    	//Saucecicle,Surge of Icing are guesses
        foreach s in $skills[Awesome Balls of Fire,Bake,Blend,Blinding Flash,Boil,Candyblast,Cannelloni Cannon,Carbohydrate Cudgel,Chop,CLEESH,Conjure Relaxing Campfire,Creepy Lullaby,Curdle,Doubt Shackles,Eggsplosion,Fear Vapor,Fearful Fettucini,Freeze,Fry,Grease Lightning,Grill,Haggis Kick,Inappropriate Backrub,K&auml;seso&szlig;esturm,Mudbath,Noodles of Fire,Rage Flame,Raise Backup Dancer,Ravioli Shurikens,Salsaball,Saucegeyser,Saucemageddon,Saucestorm,Saucy Salve,Shrap,Slice,Snowclone,Spaghetti Spear,Stream of Sauce,Stringozzi Serpent,Stuffed Mortar Shell,Tear Wave,Toynado,Volcanometeor Showeruption,Wassail,Wave of Sauce,Weapon of the Pastalord,Saucecicle,Surge of Icing]
        {
            __combat_skills_that_are_spells[s] = true;
        }
        foreach s in $skills[Lavafava,Pungent Mung,Beanstorm] //FIXME cowcall? snakewhip?
            __combat_skills_that_are_spells[s] = true;
    }
    initialiseCombatSkillsThatAreSpells();
}

static
{
    boolean [monster] __snakes;
    void initialiseSnakes()
    {
        __snakes = $monsters[aggressive grass snake,Bacon snake,Batsnake,Black adder,Burning Snake of Fire,Coal snake,Diamondback rattler,Frontwinder,Frozen Solid Snake,King snake,Licorice snake,Mutant rattlesnake,Prince snake,Sewer snake with a sewer snake in it,Snakeleton,The Snake With Like Ten Heads,Tomb asp,Trouser Snake,Whitesnake];
    }
    initialiseSnakes();
}

item lookupAWOLOilForMonster(monster m)
{
    if (__snakes contains m)
        return $item[snake oil];
    else if ($phylums[beast,dude,hippy,humanoid,orc,pirate] contains m.phylum)
        return $item[skin oil];
    else if ($phylums[bug,construct,constellation,demon,elemental,elf,fish,goblin,hobo,horror,mer-kin,penguin,plant,slime,weird] contains m.phylum)
        return $item[unusual oil];
    else if ($phylums[undead] contains m.phylum)
        return $item[eldritch oil];
    return $item[none];
}

static
{
    monster [location] __protonic_monster_for_location {$location[Cobb's Knob Treasury]:$monster[The ghost of Ebenoozer Screege], $location[The Haunted Conservatory]:$monster[The ghost of Lord Montague Spookyraven], $location[The Haunted Gallery]:$monster[The ghost of Waldo the Carpathian], $location[The Haunted Kitchen]:$monster[The Icewoman], $location[The Haunted Wine Cellar]:$monster[The ghost of Jim Unfortunato], $location[The Icy Peak]:$monster[The ghost of Sam McGee], $location[Inside the Palindome]:$monster[Emily Koops, a spooky lime], $location[Madness Bakery]:$monster[the ghost of Monsieur Baguelle], $location[The Old Landfill]:$monster[The ghost of Vanillica "Trashblossom" Gorton], $location[The Overgrown Lot]:$monster[the ghost of Oily McBindle], $location[The Skeleton Store]:$monster[boneless blobghost], $location[The Smut Orc Logging Camp]:$monster[The ghost of Richard Cockingham], $location[The Spooky Forest]:$monster[The Headless Horseman]};
}



static
{
	boolean [monster][location] __monsters_natural_habitats;
}
boolean [location] getPossibleLocationsMonsterCanAppearInNaturally(monster m)
{
	if (__monsters_natural_habitats.count() == 0)
	{
		//initialise:
        foreach l in $locations[]
        {
        	foreach key, m in l.get_monsters()
            	__monsters_natural_habitats[m][l] = true;
        }
	}
	return __monsters_natural_habitats[m];
}

boolean mafiaIsPastRevision(int revision_number)
{
    if (get_revision() <= 0) //get_revision reports zero in certain cases; assume they're on a recent version
        return true;
    return (get_revision() >= revision_number);
}


boolean have_familiar_replacement(familiar f)
{
    //have_familiar bugs in avatar of sneaky pete for now, so:
    if (my_path().id == PATH_AVATAR_OF_BORIS || my_path().id == PATH_AVATAR_OF_JARLSBERG || my_path().id == PATH_AVATAR_OF_SNEAKY_PETE)
        return false;
    return f.have_familiar();
}

//Similar to have_familiar, except it also checks trendy (not sure if have_familiar supports trendy) and 100% familiar runs
boolean familiar_is_usable(familiar f)
{
    //r13998 has most of these
    if (my_path().id == PATH_AVATAR_OF_BORIS || my_path().id == PATH_AVATAR_OF_JARLSBERG || my_path().id == PATH_AVATAR_OF_SNEAKY_PETE || my_path().id == PATH_ACTUALLY_ED_THE_UNDYING || my_path().id == PATH_LICENSE_TO_ADVENTURE || my_path().id == PATH_POCKET_FAMILIARS || my_path().id == PATH_VAMPIRE)
        return false;
    if (!is_unrestricted(f))
        return false;
    if (my_path().id == PATH_G_LOVER && !f.contains_text("g") && !f.contains_text("G"))
        return false;
    //On second thought, this is terrible:
	/*int single_familiar_run = get_property_int("singleFamiliarRun");
	if (single_familiar_run != -1 && my_turncount() >= 30) //after 30 turns, they're probably sure
	{
		if (f == single_familiar_run.to_familiar())
			return true;
		return false;
	}*/
	if (my_path().id == PATH_TRENDY)
	{
		if (!is_trendy(f))
			return false;
	}
	else if (my_path().id == PATH_BEES_HATE_YOU)
	{
		if (f.to_string().contains_text("b") || f.to_string().contains_text("B")) //bzzzz!
			return false; //so not green
	}
	return have_familiar(f);
}

//inigo's used to show up as have_skill while under restrictions, possibly others
boolean skill_is_usable(skill s)
{
    if (!s.have_skill())
        return false;
    if (!s.is_unrestricted())
        return false;
    if (my_path().id == PATH_G_LOVER && (!s.passive || s == $skill[meteor lore]) && !s.contains_text("g") && !s.contains_text("G"))
    	return false;
    if ($skills[rapid prototyping] contains s)
        return $item[hand turkey outline].is_unrestricted();
    return true;
}

boolean a_skill_is_usable(boolean [skill] skills)
{
	foreach s in skills
	{
		if (s.skill_is_usable()) return true;
	}
	return false;
}

boolean skill_is_currently_castable(skill s)
{
	//FIXME accordion thief songs, MP, a lot of things
    if (s == $skill[Utensil Twist] && $slot[weapon].equipped_item().item_type() != "utensil")
    {
        return false;
    }
    return true;
}

boolean item_is_usable(item it)
{
    if (!it.is_unrestricted())
        return false;
    if (my_path().id == PATH_G_LOVER && !it.contains_text("g") && !it.contains_text("G"))
        return false;
    if (my_path().id == PATH_BEES_HATE_YOU && (it.contains_text("b") || it.contains_text("B")))
    	return false;
	return true;
}

//available_amount() except it tests against item_is_usable()
int usable_amount(item it)
{
	if (!it.item_is_usable()) return 0;
	return it.available_amount();
}

boolean effect_is_usable(effect e)
{
    if (my_path().id == PATH_G_LOVER && !e.contains_text("g") && !e.contains_text("G"))
        return false;
    return true;
}

boolean in_ronin()
{
	return !can_interact();
}


boolean [item] makeConstantItemArrayMutable(boolean [item] array)
{
    boolean [item] result;
    foreach k in array
        result[k] = array[k];
    
    return result;
}

boolean [location] makeConstantLocationArrayMutable(boolean [location] locations)
{
    boolean [location] result;
    foreach k in locations
        result[k] = locations[k];
    
    return result;
}

boolean [skill] makeConstantSkillArrayMutable(boolean [skill] array)
{
    boolean [skill] result;
    foreach k in array
        result[k] = array[k];
    
    return result;
}

boolean [effect] makeConstantEffectArrayMutable(boolean [effect] array)
{
    boolean [effect] result;
    foreach k in array
        result[k] = array[k];
    
    return result;
}

boolean [int] makeConstantIntArrayMutable(boolean [int] array)
{
    boolean [int] result;
    foreach k in array
        result[k] = array[k];
    
    return result;
}

//Same as my_primestat(), except refers to substat
stat my_primesubstat()
{
	if (my_primestat() == $stat[muscle])
		return $stat[submuscle];
	else if (my_primestat() == $stat[mysticality])
		return $stat[submysticality];
	else if (my_primestat() == $stat[moxie])
		return $stat[submoxie];
	return $stat[none];
}

item [int] items_missing(boolean [item] items)
{
    item [int] result;
    foreach it in items
    {
        if (it.available_amount() == 0)
            result.listAppend(it);
    }
    return result;
}

skill [int] skills_missing(boolean [skill] skills)
{
    skill [int] result;
    foreach s in skills
    {
        if (!s.have_skill())
            result.listAppend(s);
    }
    return result;
}

int storage_amount(boolean [item] items)
{
    int count = 0;
    foreach it in items
    {
        count += it.storage_amount();
    }
    return count;
}

int available_amount(boolean [item] items)
{
    //Usage:
    //$items[disco ball, corrupted stardust].available_amount()
    //Returns the total number of all items.
    int count = 0;
    foreach it in items
    {
        count += it.available_amount();
    }
    return count;
}

int creatable_amount(boolean [item] items)
{
    //Usage:
    //$items[disco ball, corrupted stardust].available_amount()
    //Returns the total number of all items.
    int count = 0;
    foreach it in items
    {
        count += it.creatable_amount();
    }
    return count;
}

int item_amount(boolean [item] items)
{
    int count = 0;
    foreach it in items
    {
        count += it.item_amount();
    }
    return count;
}

int have_effect(boolean [effect] effects)
{
    int count = 0;
    foreach e in effects
        count += e.have_effect();
    return count;
}

int available_amount(item [int] items)
{
    int count = 0;
    foreach key in items
    {
        count += items[key].available_amount();
    }
    return count;
}

int available_amount_ignoring_storage(item it)
{
    if (!in_ronin())
        return it.available_amount() - it.storage_amount();
    else
        return it.available_amount();
}

int available_amount_ignoring_closet(item it)
{
    if (get_property_boolean("autoSatisfyWithCloset"))
        return it.available_amount() - it.closet_amount();
    else
        return it.available_amount();
}

int available_amount_including_closet(item it)
{
    if (get_property_boolean("autoSatisfyWithCloset"))
        return it.available_amount();
    else
        return it.available_amount() + it.closet_amount();
}

//Display case, etc
//WARNING: Does not take into account your shop. Conceptually, the shop is things you're getting rid of... and they might be gone already.
int item_amount_almost_everywhere(item it)
{
    return it.closet_amount() + it.display_amount() + it.equipped_amount() + it.item_amount() + it.storage_amount();
}

//Similar to item_amount_almost_everywhere, but won't trigger a display case load unless it has to:
boolean haveAtLeastXOfItemEverywhere(item it, int amount)
{
    int total = 0;
    total += it.item_amount();
    if (total >= amount) return true;
    total += it.equipped_amount();
    if (total >= amount) return true;
    total += it.closet_amount();
    if (total >= amount) return true;
    total += it.storage_amount();
    if (total >= amount) return true;
    total += it.display_amount();
    if (total >= amount) return true;
    
    return false;
}

int equipped_amount(boolean [item] items)
{
    int count = 0;
    foreach it in items
    {
        count += it.equipped_amount();
    }
    return count;
}

int [item] creatable_items(boolean [item] items)
{
    int [item] creatable_items;
    foreach it in items
    {
        if (it.creatable_amount() == 0)
            continue;
        creatable_items[it] = it.creatable_amount();
    }
    return creatable_items;
}


item [slot] equipped_items()
{
    item [slot] result;
    foreach s in $slots[]
    {
        item it = s.equipped_item();
        if (it == $item[none])
            continue;
        result[s] = it;
    }
    return result;
}

//Have at least one of these familiars:
boolean have_familiar_replacement(boolean [familiar] familiars)
{
    foreach f in familiars
    {
        if (f.have_familiar())
            return true;
    }
    return false;
}

item [int] missing_outfit_components(string outfit_name)
{
    item [int] outfit_pieces = outfit_pieces(outfit_name);
    item [int] missing_components;
    foreach key in outfit_pieces
    {
        item it = outfit_pieces[key];
        if (it.available_amount() == 0)
            missing_components.listAppend(it);
    }
    return missing_components;
}


//have_outfit() will tell you if you have an outfit, but only if you pass stat checks. This does not stat check:
boolean have_outfit_components(string outfit_name)
{
    return (outfit_name.missing_outfit_components().count() == 0);
}

//Non-API-related functions:

boolean playerIsLoggedIn()
{
    return !(my_hash().length() == 0 || my_id() == 0);
}

int substatsForLevel(int level)
{
	if (level == 1)
		return 0;
	return pow2i(pow2i(level - 1) + 4);
}

int availableFullness()
{
	int limit = fullness_limit();
    if (my_path().id == PATH_ACTUALLY_ED_THE_UNDYING && limit == 0 && $skill[Replacement Stomach].have_skill())
    {
        limit += 5;
    }
	return limit - my_fullness();
}

int availableDrunkenness()
{
    int limit = inebriety_limit();
    if (my_path().id == PATH_ACTUALLY_ED_THE_UNDYING && limit == 0 && $skill[Replacement Liver].have_skill())
    {
    	limit += 5;
    }
    if (limit == 0) return 0; //certain edge cases
	return limit - my_inebriety();
}

int availableSpleen()
{
	int limit = spleen_limit();
	if (my_path().id == PATH_ACTUALLY_ED_THE_UNDYING && limit == 0)
	{
        limit += 5; //always true
		//mafia resets the limits to zero in the underworld because it does, so anti-mafia:
        foreach s in $skills[Extra Spleen,Another Extra Spleen,Yet Another Extra Spleen,Still Another Extra Spleen,Just One More Extra Spleen,Okay Seriously\, This is the Last Spleen]
        {
        	if (s.have_skill())
         		limit += 5;
        }
	} 
	return limit - my_spleen_use();
}

item [int] missingComponentsToMakeItemPrivateImplementation(item it, int it_amounted_needed, int recursion_limit_remaining)
{
	item [int] result;
    if (recursion_limit_remaining <= 0) //possible loop
        return result;
    if ($items[dense meat stack,meat stack] contains it) return listMake(it); //meat from yesterday + fairy gravy boat? hmm... no
	if (it.available_amount() >= it_amounted_needed)
        return result;
	int [item] ingredients = get_ingredients_fast(it);
	if (ingredients.count() == 0)
    {
        for i from 1 to (it_amounted_needed - it.available_amount())
            result.listAppend(it);
    }
	foreach ingredient in ingredients
	{
		int ingredient_amounted_needed = ingredients[ingredient];
		if (ingredient.available_amount() >= ingredient_amounted_needed) //have enough
            continue;
		//split:
		item [int] r = missingComponentsToMakeItemPrivateImplementation(ingredient, ingredient_amounted_needed, recursion_limit_remaining - 1);
        if (r.count() > 0)
        {
            result.listAppendList(r);
        }
	}
	return result;
}

item [int] missingComponentsToMakeItem(item it, int it_amounted_needed)
{
    return missingComponentsToMakeItemPrivateImplementation(it, it_amounted_needed, 30);
}


item [int] missingComponentsToMakeItem(item it)
{
    return missingComponentsToMakeItem(it, 1);
}

string [int] missingComponentsToMakeItemInHumanReadableFormat(item it)
{
    item [int] parts = missingComponentsToMakeItem(it);
    
    int [item] parts_inverted;
    foreach key, it2 in parts
    {
        parts_inverted[it2] += 1;
    }
    string [int] result;
    foreach it2, amount in parts_inverted
    {
        string line = amount;
        line += " more ";
        if (amount > 1)
            line += it2.plural;
        else
            line += it2.to_string();
        result.listAppend(line);
    }
    return result;
}

//For tracking time deltas. Won't accurately compare across day boundaries and isn't monotonic (be wary of negative deltas), but still useful for temporal rate limiting.
int getMillisecondsOfToday()
{
    //To replicate value in GCLI:
    //ash (now_to_string("H").to_int() * 60 * 60 * 1000 + now_to_string("m").to_int() * 60 * 1000 + now_to_string("s").to_int() * 1000 + now_to_string("S").to_int())
    return now_to_string("H").to_int_silent() * 60 * 60 * 1000 + now_to_string("m").to_int_silent() * 60 * 1000 + now_to_string("s").to_int_silent() * 1000 + now_to_string("S").to_int_silent();
}

//WARNING: Only accurate for up to five turns.
//It also will not work properly in certain areas, and possibly across day boundaries. Actually, it's kind of a hack.
//But now we have turns_spent so no need to worry.
int combatTurnsAttemptedInLocation(location place)
{
    int count = 0;
    if (place.combat_queue != "")
        count += place.combat_queue.split_string_alternate("; ").count();
    return count;
}

int noncombatTurnsAttemptedInLocation(location place)
{
    int count = 0;
    if (place.noncombat_queue != "")
        count += place.noncombat_queue.split_string_alternate("; ").count();
    return count;
}

int turnsAttemptedInLocation(location place)
{
    return place.turns_spent;
}

int turnsAttemptedInLocation(boolean [location] places)
{
    int count = 0;
    foreach place in places
        count += place.turnsAttemptedInLocation();
    return count;
}

string [int] locationSeenNoncombats(location place)
{
    return place.noncombat_queue.split_string_alternate("; ");
}

string [int] locationSeenCombats(location place)
{
    return place.combat_queue.split_string_alternate("; ");
}

string lastNoncombatInLocation(location place)
{
    if (place.noncombat_queue != "")
        return place.locationSeenNoncombats().listLastObject();
    return "";
}

string lastCombatInLocation(location place)
{
    if (place.noncombat_queue != "")
        return place.locationSeenCombats().listLastObject();
    return "";
}

static
{
    int [location] __place_delays;
    __place_delays[$location[the spooky forest]] = 5;
    __place_delays[$location[the haunted bedroom]] = 6; //a guess from spading
    __place_delays[$location[the boss bat's lair]] = 4;
    __place_delays[$location[the oasis]] = 5;
    __place_delays[$location[the hidden park]] = 6; //6? does turkey blaster give four turns sometimes...?
    __place_delays[$location[the haunted gallery]] = 5; //FIXME this is a guess, spade
    __place_delays[$location[the haunted bathroom]] = 5;
    __place_delays[$location[the haunted ballroom]] = 5; //FIXME rumored
    __place_delays[$location[the penultimate fantasy airship]] = 25;
    __place_delays[$location[the "fun" house]] = 10;
    __place_delays[$location[The Castle in the Clouds in the Sky (Ground Floor)]] = 10;
    __place_delays[$location[the outskirts of cobb's knob]] = 10;
    __place_delays[$location[the hidden apartment building]] = 8;
    __place_delays[$location[the hidden office building]] = 10;
    __place_delays[$location[the upper chamber]] = 5;
}

int totalDelayForLocation(location place)
{
    //the haunted billiards room does not contain delay
    //also failure at 16 skill
    
    if (__place_delays contains place)
        return __place_delays[place];
    return -1;
}

int delayRemainingInLocation(location place)
{
    int delay_for_place = place.totalDelayForLocation();
    
    if (delay_for_place == -1)
        return -1;
    
    int turns_attempted = place.turns_spent;
    
    return MAX(0, delay_for_place - turns_attempted);
}

int turnsCompletedInLocation(location place)
{
    return place.turnsAttemptedInLocation(); //FIXME make this correct
}

//Backwards compatibility:
//We want to be able to support new content with daily builds. But, we don't want to ask users to run a daily build.
//So these act as replacements for new content. Unknown lookups are given as $type[none] The goal is to have compatibility with the last major release.
//We use this instead of to_item() conversion functions, so we can easily identify them in the source.
item lookupItem(string name)
{
    return name.to_item();
}

boolean [item] lookupItems(string names) //CSV input
{
    boolean [item] result;
    string [int] item_names = split_string_alternate(names, ",");
    foreach key in item_names
    {
        item it = item_names[key].to_item();
        if (it == $item[none])
            continue;
        result[it] = true;
    }
    return result;
}

boolean [item] lookupItemsArray(boolean [string] names)
{
    boolean [item] result;
    
    foreach item_name in names
    {
        item it = item_name.to_item();
        if (it == $item[none])
            continue;
        result[it] = true;
    }
    return result;
}

skill lookupSkill(string name)
{
    return name.to_skill();
}

boolean [skill] lookupSkills(string names) //CSV input
{
    boolean [skill] result;
    string [int] skill_names = split_string_alternate(names, ",");
    foreach key in skill_names
    {
        skill s = skill_names[key].to_skill();
        if (s == $skill[none])
            continue;
        result[s] = true;
    }
    return result;
}


//lookupSkills(string) will be called instead if we keep the same name, so use a different name:
boolean [skill] lookupSkillsInt(boolean [int] skill_ids)
{
    boolean [skill] result;
    foreach skill_id in skill_ids
    {
        skill s = skill_id.to_skill();
        if (s == $skill[none])
            continue;
        result[s] = true;
    }
    return result;
}

effect lookupEffect(string name)
{
    return name.to_effect();
}

familiar lookupFamiliar(string name)
{
    return name.to_familiar();
}

location lookupLocation(string name)
{
    return name.to_location();
    /*l = name.to_location();
    if (__setting_debug_mode && l == $location[none])
        print_html("Unable to find location \"" + name + "\"");
    return l;*/
}

boolean [location] lookupLocations(string names_string)
{
    boolean [location] result;
    
    string [int] names = names_string.split_string(",");
    foreach key, name in names
    {
        if (name.length() == 0)
            continue;
        location l = name.to_location();
        if (l != $location[none])
            result[l] = true;
    }
    
    return result;
}

monster lookupMonster(string name)
{
    return name.to_monster();
}

boolean [monster] lookupMonsters(string names_string)
{
    boolean [monster] result;
    
    string [int] names = names_string.split_string(",");
    foreach key, name in names
    {
        if (name.length() == 0)
            continue;
        monster m = name.to_monster();
        if (m != $monster[none])
            result[m] = true;
    }
    
    return result;
}

class lookupClass(string name)
{
    return name.to_class();
}

boolean monsterDropsItem(monster m, item it)
{
	//record [int] drops = m.item_drops_array();
	foreach key in m.item_drops_array()
	{
		if (m.item_drops_array()[key].drop == it)
			return true;
	}
	return false;
}


Record StringHandle
{
    string s;
};

Record FloatHandle
{
    float f;
};


buffer generateTurnsToSeeNoncombat(int combat_rate, int noncombats_in_zone, string task, int max_turns_between_nc, int extra_starting_turns)
{
    float turn_estimation = -1.0;
    float combat_rate_modifier = combat_rate_modifier();
    float noncombat_rate = 1.0 - (combat_rate + combat_rate_modifier).to_float() / 100.0;
    
    
    if (noncombats_in_zone > 0)
    {
        float minimum_nc_rate = 0.0;
        if (max_turns_between_nc != 0)
            minimum_nc_rate = 1.0 / max_turns_between_nc.to_float();
        if (noncombat_rate < minimum_nc_rate)
            noncombat_rate = minimum_nc_rate;
        
        if (noncombat_rate > 0.0)
            turn_estimation = noncombats_in_zone.to_float() / noncombat_rate;
    }
    else
        turn_estimation = 0.0;
    
    turn_estimation += extra_starting_turns;
    
    
    buffer result;
    
    if (turn_estimation == -1.0)
    {
        result.append("Impossible");
    }
    else
    {
        result.append("~");
        result.append(turn_estimation.roundForOutput(1));
        if (turn_estimation == 1.0)
            result.append(" turn");
        else
            result.append(" turns");
    }
    
    if (task != "")
    {
        result.append(" to ");
        result.append(task);
    }
    else
    {
        if (turn_estimation == -1.0)
        {
        }
        else if (turn_estimation == 1.0)
            result.append(" remains");
        else
            result.append(" remain");
    }
    if (noncombats_in_zone > 0)
    {
        result.append(" at ");
        result.append(combat_rate_modifier.floor());
        result.append("% combat rate");
    }
    result.append(".");
    
    return result;
}

buffer generateTurnsToSeeNoncombat(int combat_rate, int noncombats_in_zone, string task, int max_turns_between_nc)
{
    return generateTurnsToSeeNoncombat(combat_rate, noncombats_in_zone, task, max_turns_between_nc, 0);
}

buffer generateTurnsToSeeNoncombat(int combat_rate, int noncombats_in_zone, string task)
{
    return generateTurnsToSeeNoncombat(combat_rate, noncombats_in_zone, task, 0);
}


int damageTakenByElement(int base_damage, float elemental_resistance)
{
    if (base_damage < 0)
        return 1;
    
    float effective_base_damage = MAX(30, base_damage).to_float();
    
    return MAX(1, ceil(base_damage.to_float() - effective_base_damage * elemental_resistance));
}

int damageTakenByElement(int base_damage, element e)
{
    float elemental_resistance = e.elemental_resistance() / 100.0;
    
    //mafia might already do this for us already, but I haven't checked:
    
    if (e == $element[cold] && $effect[coldform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[hot] && $effect[hotform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[sleaze] && $effect[sleazeform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[spooky] && $effect[spookyform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[stench] && $effect[stenchform].have_effect() > 0)
        elemental_resistance = 1.0;
        
        
    return damageTakenByElement(base_damage, elemental_resistance);
}

boolean locationHasPlant(location l, string plant_name)
{
    string [int] plants_in_place = get_florist_plants()[l];
    foreach key in plants_in_place
    {
        if (plants_in_place[key] == plant_name)
            return true;
    }
    return false;
}

float initiative_modifier_ignoring_plants()
{
    //FIXME strange bug here, investigate
    //seen in cyrpt
    float init = initiative_modifier();
    
    location my_location = my_location();
    if (my_location != $location[none] && (my_location.locationHasPlant("Impatiens") || my_location.locationHasPlant("Shuffle Truffle")))
        init -= 25.0;
    
    return init;
}

float item_drop_modifier_ignoring_plants()
{
    float modifier_value = item_drop_modifier();
    
    location my_location = my_location();
    if (my_location != $location[none])
    {
        if (my_location.locationHasPlant("Rutabeggar") || my_location.locationHasPlant("Stealing Magnolia"))
            modifier_value -= 25.0;
        if (my_location.locationHasPlant("Kelptomaniac"))
            modifier_value -= 40.0;
    }
    return modifier_value;
}

int monster_level_adjustment_ignoring_plants() //this is unsafe to use in heavy rains
{
    //FIXME strange bug possibly here, investigate
    int ml = monster_level_adjustment();
    
    location my_location = my_location();
    
    if (my_location != $location[none])
    {
        string [3] location_plants = get_florist_plants()[my_location];
        foreach key in location_plants
        {
            string plant = location_plants[key];
            if (plant == "Rabid Dogwood" || plant == "War Lily"  || plant == "Blustery Puffball")
            {
                ml -= 30;
                break;
            }
        }
        
    }
    return ml;
}

int water_level_of_location(location l)
{
    int water_level = 1;
    if (l.recommended_stat >= 40) //FIXME is this threshold spaded?
        water_level += 1;
    if (l.environment == "indoor")
        water_level += 2;
    if (l.environment == "underground" || l == $location[the lower chambers]) //per-location fix
        water_level += 4;
    water_level += numeric_modifier("water level");
    
    water_level = clampi(water_level, 1, 6);
    if (l.environment == "underwater") //or does the water get the rain instead? nobody knows, rain man
        water_level = 0; //the aquaman hates rain man, they have a fight, aquaman wins
    return water_level;
}

float washaway_rate_of_location(location l)
{
    //Calculate washaway chance:
    int current_water_level = l.water_level_of_location();
    
    int washaway_chance = current_water_level * 5;
    if ($item[fishbone catcher's mitt].equipped_amount() > 0)
        washaway_chance -= 15; //GUESS
    
    if ($effect[Fishy Whiskers].have_effect() > 0)
    {
        //washaway_chance -= ?; //needs spading
    }
    return clampNormalf(washaway_chance / 100.0);
}

int monster_level_adjustment_for_location(location l)
{
    int ml = monster_level_adjustment_ignoring_plants();
    
    if (l.locationHasPlant("Rabid Dogwood") || l.locationHasPlant("War Lily") || l.locationHasPlant("Blustery Puffball"))
    {
        ml += 30;
    }
    
    if (my_path().id == PATH_HEAVY_RAINS)
    {
        //complicated:
        //First, cancel out the my_location() rain:
        int my_location_water_level_ml = monster_level_adjustment() - numeric_modifier("Monster Level");
        ml -= my_location_water_level_ml;
        
        //Now, calculate the water level for the location:
        int water_level = water_level_of_location(l);
        
        //Add that as ML:
        if (!($locations[oil peak,the typical tavern cellar] contains l)) //kind of hacky to put this here, sorry
        {
            ml += water_level * 10;
        }
    }
    
    return ml;
}

float initiative_modifier_for_location(location l)
{
    float base = initiative_modifier_ignoring_plants();
    
    if (l.locationHasPlant("Impatiens") || l.locationHasPlant("Shuffle Truffle"))
        base += 25.0;
    return base;
}

float item_drop_modifier_for_location(location l)
{
    int base = item_drop_modifier_ignoring_plants();
    if (l.locationHasPlant("Rutabeggar") || l.locationHasPlant("Stealing Magnolia"))
        base += 25.0;
    if (l.locationHasPlant("Kelptomaniac"))
        base += 40.0;
    return base;
}

int monsterExtraInitForML(int ml)
{
	if (ml < 21)
		return 0.0;
	else if (ml < 41)
		return 0.0 + 1.0 * (ml - 20.0);
	else if (ml < 61)
		return 20.0 + 2.0 * (ml - 40.0);
	else if (ml < 81)
		return 60.0 + 3.0 * (ml - 60.0);
	else if (ml < 101)
		return 120.0 + 4.0 * (ml - 80.0);
	else
		return 200.0 + 5.0 * (ml - 100.0);
}

int stringCountSubstringMatches(string str, string substring)
{
    int count = 0;
    int position = 0;
    int breakout = 100;
    int str_length = str.length(); //uncertain whether this is a constant time operation
    while (breakout > 0 && position + 1 < str_length)
    {
        position = str.index_of(substring, position + 1);
        if (position != -1)
            count += 1;
        else
            break;
        breakout -= 1;
    }
    return count;
}

effect to_effect(item it)
{
	return it.effect_modifier("effect");
}



boolean weapon_is_club(item it)
{
    if (it.to_slot() != $slot[weapon]) return false;
    if (it.item_type() == "club")
        return true;
    if (it.item_type() == "sword" && $effect[Iron Palms].have_effect() > 0)
        return true;
    return false;
}

boolean weapon_is_sword(item it)
{
    if (it.to_slot() != $slot[weapon]) return false;
    if (it.item_type() == "sword" && $effect[Iron Palms].have_effect() == 0)
        return true;
    return false;
}

buffer prepend(buffer in_buffer, buffer value)
{
    buffer result;
    result.append(value);
    result.append(in_buffer);
    in_buffer.set_length(0);
    in_buffer.append(result);
    return result;
}

buffer prepend(buffer in_buffer, string value)
{
    return prepend(in_buffer, value.to_buffer());
}

float pressurePenaltyForLocation(location l, Error could_get_value)
{
    float pressure_penalty = 0.0;
    
    if (my_location() != l)
    {
        ErrorSet(could_get_value);
        return -1.0;
    }
    
    pressure_penalty = MAX(0, -numeric_modifier("item drop penalty"));
    return pressure_penalty;
}

int XiblaxianHoloWristPuterTurnsUntilNextItem()
{
    int drops = get_property_int("_holoWristDrops");
    int progress = get_property_int("_holoWristProgress");
    
    //_holoWristProgress resets when drop happens
    int next_turn_hit = 5 * (drops + 1) + 6;
    return MAX(0, next_turn_hit - progress);
}

int ka_dropped(monster m)
{
    if (m.phylum == $phylum[dude] || m.phylum == $phylum[hobo] || m.phylum == $phylum[hippy] || m.phylum == $phylum[pirate])
        return 2;
    if (m.phylum == $phylum[goblin] || m.phylum == $phylum[humanoid] || m.phylum == $phylum[beast] || m.phylum == $phylum[bug] || m.phylum == $phylum[orc] || m.phylum == $phylum[elemental] || m.phylum == $phylum[elf] || m.phylum == $phylum[penguin])
        return 1;
    return 0;
}


boolean is_underwater_familiar(familiar f)
{
    return $familiars[Barrrnacle,Emo Squid,Cuddlefish,Imitation Crab,Magic Dragonfish,Midget Clownfish,Rock Lobster,Urchin Urchin,Grouper Groupie,Squamous Gibberer,Dancing Frog,Adorable Space Buddy] contains f;
}

float calculateCurrentNinjaAssassinMaxDamage()
{
    
	//float assassin_ml = 155.0 + monster_level_adjustment();
    float assassin_ml = $monster[ninja snowman assassin].base_attack + 5.0;
	float damage_absorption = raw_damage_absorption();
	float damage_reduction = damage_reduction();
	float moxie = my_buffedstat($stat[moxie]);
	float cold_resistance = numeric_modifier("cold resistance");
	float v = 0.0;
	
	//spaded by yojimboS_LAW
	//also by soirana
    
	float myst_class_extra_cold_resistance = 0.0;
	if (my_class() == $class[pastamancer] || my_class() == $class[sauceror] || my_class() == $class[avatar of jarlsberg])
		myst_class_extra_cold_resistance = 0.05;
	//Direct from the spreadsheet:
	if (cold_resistance < 9)
		v = ((((MAX((assassin_ml - moxie), 0.0) - damage_reduction) + 120.0) * MAX(0.1, MIN((1.1 - sqrt((damage_absorption/1000.0))), 1.0))) * ((1.0 - myst_class_extra_cold_resistance) - ((0.1) * MAX((cold_resistance - 5.0), 0.0))));
	else
		v = ((((MAX((assassin_ml - moxie), 0.0) - damage_reduction) + 120.0) * MAX(0.1, MIN((1.1 - sqrt((damage_absorption/1000.0))), 1.0))) * (0.1 - myst_class_extra_cold_resistance + (0.5 * (powf((5.0/6.0), (cold_resistance - 9.0))))));
	
    
    
	return v;
}

float calculateCurrentNinjaAssassinMaxEnvironmentalDamage()
{
    float v = 0.0;
    int ml_level = monster_level_adjustment_ignoring_plants();
    if (ml_level >= 25)
    {
        float expected_assassin_damage = 0.0;
        
        expected_assassin_damage = ((150 + ml_level) * (ml_level - 25)).to_float() / 500.0;
        
        expected_assassin_damage = expected_assassin_damage + ceiling(expected_assassin_damage / 11.0); //upper limit
        
        //FIXME add in resists later
        //Resists don't work properly. They have an effect, but it's different. I don't know how much exactly, so for now, ignore this:
        //I think they're probably just -5 like above
        //expected_assassin_damage = damageTakenByElement(expected_assassin_damage, $element[cold]);
        
        expected_assassin_damage = ceil(expected_assassin_damage);
        
        v += expected_assassin_damage;
    }
    return v;
}

//mafia describes "merkin" for the "mer-kin" phylum, which "to_phylum()" does not interpret
//hmm... maybe file a request for to_phylum() to parse that
phylum getDNASyringePhylum()
{
    string phylum_text = get_property("dnaSyringe");
    if (phylum_text == "merkin")
        return $phylum[mer-kin];
    else
        return phylum_text.to_phylum();
}

int nextLibramSummonMPCost()
{
    int libram_summoned = get_property_int("libramSummons");
    int next_libram_summoned = libram_summoned + 1;
    int libram_mp_cost = MAX(1 + (next_libram_summoned * (next_libram_summoned - 1)/2) + mana_cost_modifier(), 1);
    return libram_mp_cost;
}

int maximumSimultaneous1hWeaponsEquippable()
{
    int weapon_maximum = 1;
    if ($skill[double-fisted skull smashing].skill_is_usable())
        weapon_maximum += 1;
    if (my_familiar() == $familiar[disembodied hand])
        weapon_maximum += 1;
    return weapon_maximum;
}

int equippable_amount(item it)
{
    if (!it.can_equip()) return it.equipped_amount();
    if (it.available_amount() == 0) return 0;
    if ($slots[acc1, acc2, acc3] contains it.to_slot() && it.available_amount() > 1 && !it.boolean_modifier("Single equip"))
        return MIN(3, it.available_amount());
    if (it.to_slot() == $slot[weapon] && it.weapon_hands() == 1)
    {
        return MIN(maximumSimultaneous1hWeaponsEquippable(), it.available_amount());
    }
    return 1;
}

boolean haveSeenBadMoonEncounter(int encounter_id)
{
    if (!get_property_ascension("lastBadMoonReset")) //badMoonEncounter values are not reset when you ascend
        return false;
    return get_property_boolean("badMoonEncounter" + encounter_id);
}

//FIXME make this use static etc. Probably extend Item Filter.ash to support equipment.
item [int] generateEquipmentForExtraExperienceOnStat(stat desired_stat, boolean require_can_equip_currently)
{
    //boolean [item] experience_percent_modifiers;
    /*string numeric_modifier_string;
    if (desired_stat == $stat[muscle])
    {
        //experience_percent_modifiers = $items[trench lighter,fake washboard];
        numeric_modifier_string = "Muscle";
    }
    else if (desired_stat == $stat[mysticality])
    {
        //experience_percent_modifiers = lookupItems("trench lighter,basaltamander buckler");
        numeric_modifier_string = "Mysticality";
    }
    else if (desired_stat == $stat[moxie])
    {
        //experience_percent_modifiers = $items[trench lighter,backwoods banjo];
        numeric_modifier_string = "Moxie";
    }
    else
        return listMakeBlankItem();
    if (numeric_modifier_string != "")
        numeric_modifier_string += " Experience Percent";*/
        
    item [slot] item_slots;
    string numeric_modifier_string = desired_stat + " Experience Percent";

    //foreach it in experience_percent_modifiers
    foreach it in equipmentWithNumericModifier(numeric_modifier_string)
    {
    	slot s = it.to_slot();
        if (s == $slot[shirt] && !(lookupSkill("Torso Awareness").have_skill() || $skill[Best Dressed].have_skill()))
        	continue;
        if (s == $slot[weapon] && it.weapon_hands() > 1 && item_slots[$slot[off-hand]] != $item[none]) //can't equip an off-hand and a two-handed weapon
        	continue;
        if (it.available_amount() > 0 && (!require_can_equip_currently || it.can_equip()) && item_slots[it.to_slot()].numeric_modifier(numeric_modifier_string) < it.numeric_modifier(numeric_modifier_string))
        {
            item_slots[it.to_slot()] = it;
            if (s == $slot[weapon] && it.weapon_hands() > 1)
            {
                item_slots[$slot[off-hand]] = it;
            }
        }
    }
    
    item [int] items_could_equip;
    foreach s, it in item_slots
        items_could_equip.listAppend(it);
    return items_could_equip;
}


item [int] generateEquipmentToEquipForExtraExperienceOnStat(stat desired_stat)
{
    item [int] items_could_equip = generateEquipmentForExtraExperienceOnStat(desired_stat, true);
    item [int] items_equipping;
    foreach key, it in items_could_equip
    {
        if (it.equipped_amount() == 0)
        {
            items_equipping.listAppend(it);
        }
    }
    return items_equipping;
}



float averageAdventuresForConsumable(item it, boolean assume_monday)
{
	float adventures = 0.0;
	string [int] adventures_string = it.adventures.split_string("-");
	foreach key, v in adventures_string
	{
		float a = v.to_float();
		if (a < 0)
			continue;
		adventures += a * (1.0 / to_float(adventures_string.count()));
	}
    if (it == $item[affirmation cookie])
        adventures += 3;
    if (it == $item[White Citadel burger])
    {
        if (in_bad_moon())
            adventures = 2; //worst case scenario
        else
            adventures = 9; //saved across lifetimes
    }
	
	if ($skill[saucemaven].have_skill() && ($items[hot hi mein,cold hi mein,sleazy hi mein,spooky hi mein,stinky hi mein,Hell ramen,fettucini Inconnu,gnocchetti di Nietzsche,spaghetti with Skullheads,spaghetti con calaveras,Fleetwood mac 'n' cheese,haunted hell ramen] contains it))
	{
		if ($classes[sauceror,pastamancer] contains my_class())
			adventures += 5;
		else
			adventures += 3;
	}
	
    
	if ($skill[pizza lover].have_skill() && it.to_lower_case().contains_text("pizza"))
	{
		adventures += it.fullness;
	}
	if (it.to_lower_case().contains_text("lasagna") && !assume_monday)
		adventures += 5;
	//FIXME lasagna properly
	return adventures;
}

float averageAdventuresForConsumable(item it)
{
    return averageAdventuresForConsumable(it, false);
}

boolean [string] getInstalledSourceTerminalSingleChips()
{
    string [int] chips = get_property("sourceTerminalChips").split_string_alternate(",");
    boolean [string] result;
    foreach key, s in chips
        result[s] = true;
    return result;
}

boolean [skill] getActiveSourceTerminalSkills()
{
    string skill_1_name = get_property("sourceTerminalEducate1");
    string skill_2_name = get_property("sourceTerminalEducate2");
    
    boolean [skill] skills_have;
    if (skill_1_name != "")
        skills_have[skill_1_name.replace_string(".edu", "").to_skill()] = true;
    if (skill_2_name != "")
        skills_have[skill_2_name.replace_string(".edu", "").to_skill()] = true;
    return skills_have;
}

boolean monsterIsGhost(monster m)
{
    if (m.attributes.contains_text("GHOST"))
        return true;
    /*if ($monsters[Ancient ghost,Ancient protector spirit,Banshee librarian,Battlie Knight Ghost,Bettie Barulio,Chalkdust wraith,Claybender Sorcerer Ghost,Cold ghost,Contemplative ghost,Dusken Raider Ghost,Ghost,Ghost miner,Hot ghost,Lovesick ghost,Marcus Macurgeon,Marvin J. Sunny,Mayor Ghost,Mayor Ghost (Hard Mode),Model skeleton,Mortimer Strauss,Plaid ghost,Protector Spectre,Sexy sorority ghost,Sheet ghost,Sleaze ghost,Space Tourist Explorer Ghost,Spirit of New Wave (Inner Sanctum),Spooky ghost,Stench ghost,The ghost of Phil Bunion,Whatsian Commando Ghost,Wonderful Winifred Wongle] contains m)
        return true;
    if ($monsters[boneless blobghost,the ghost of Vanillica \"Trashblossom\" Gorton,restless ghost,The Icewoman,the ghost of Monsieur Baguelle,The ghost of Lord Montague Spookyraven,The Headless Horseman,The ghost of Ebenoozer Screege,The ghost of Sam McGee,The ghost of Richard Cockingham,The ghost of Jim Unfortunato,The ghost of Waldo the Carpathian,the ghost of Oily McBindle] contains m)
        return true;
    if ($monster[Emily Koops, a spooky lime] == m)
        return true;*/
    return false;
}

boolean item_is_pvp_stealable(item it)
{
	if (it == $item[amulet of yendor])
		return true;
	if (!it.tradeable)
		return false;
	if (!it.discardable)
		return false;
	if (it.quest)
		return false;
	if (it.gift)
		return false;
	return true;
}

int effective_familiar_weight(familiar f)
{
	if (f == $familiar[none]) return 0;
    int weight = f.familiar_weight();
    
    boolean is_moved = false;
    string [int] familiars_used_on = get_property("_feastedFamiliars").split_string_alternate(";");
    foreach key, f_name in familiars_used_on
    {
        if (f_name.to_familiar() == f)
        {
            is_moved = true;
            break;
        }
    }
    if (is_moved)
        weight += 10;
    return weight;
}

boolean year_is_leap_year(int year)
{
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    if (year % 400 != 0) return false;
    return true;
}

boolean today_is_pvp_season_end()
{
    string today = format_today_to_string("MMdd");
    if (today == "0228")
    {
        int year = format_today_to_string("yyyy").to_int();
        boolean is_leap_year = year_is_leap_year(year);
        if (!is_leap_year)
            return true;
    }
    else if (today == "0229") //will always be true, but won't always be there
        return true;
    else if (today == "0430")
        return true;
    else if (today == "0630")
        return true;
    else if (today == "0831")
        return true;
    else if (today == "1031")
        return true;
    else if (today == "1231")
        return true;
    return false;
}

boolean monster_has_zero_turn_cost(monster m)
{
    if (m.attributes.contains_text("FREE"))
        return true;
    if (m == $monster[sausage goblin] && m != $monster[none]) return true;
    if ($monsters[LOV Engineer,LOV Enforcer,LOV Equivocator] contains m) return true;
        
    if ($monsters[lynyrd] contains m) return true; //not marked as FREE in attributes
    //if ($monsters[Black Crayon Beast,Black Crayon Beetle,Black Crayon Constellation,Black Crayon Golem,Black Crayon Demon,Black Crayon Man,Black Crayon Elemental,Black Crayon Crimbo Elf,Black Crayon Fish,Black Crayon Goblin,Black Crayon Hippy,Black Crayon Hobo,Black Crayon Shambling Monstrosity,Black Crayon Manloid,Black Crayon Mer-kin,Black Crayon Frat Orc,Black Crayon Penguin,Black Crayon Pirate,Black Crayon Flower,Black Crayon Slime,Black Crayon Undead Thing,Black Crayon Spiraling Shape,broodling seal,Centurion of Sparky,heat seal,hermetic seal,navy seal,Servant of Grodstank,shadow of Black Bubbles,Spawn of Wally,watertight seal,wet seal,lynyrd,BRICKO airship,BRICKO bat,BRICKO cathedral,BRICKO elephant,BRICKO gargantuchicken,BRICKO octopus,BRICKO ooze,BRICKO oyster,BRICKO python,BRICKO turtle,BRICKO vacuum cleaner,Witchess Bishop,Witchess King,Witchess Knight,Witchess Ox,Witchess Pawn,Witchess Queen,Witchess Rook,Witchess Witch,The ghost of Ebenoozer Screege,The ghost of Lord Montague Spookyraven,The ghost of Waldo the Carpathian,The Icewoman,The ghost of Jim Unfortunato,the ghost of Sam McGee,the ghost of Monsieur Baguelle,the ghost of Vanillica "Trashblossom" Gorton,the ghost of Oily McBindle,boneless blobghost,The ghost of Richard Cockingham,The Headless Horseman,Emily Koops\, a spooky lime,time-spinner prank,random scenester,angry bassist,blue-haired girl,evil ex-girlfriend,peeved roommate] contains m)
        //return true;
    if (m == $monster[X-32-F Combat Training Snowman] && get_property_int("_snojoFreeFights") < 10)
        return true;
    if (my_familiar() == $familiar[machine elf] && my_location() == $location[the deep machine tunnels] && get_property_int("_machineTunnelsAdv") < 5)
        return true;
    if ($monsters[terrible mutant,slime blob,government bureaucrat,angry ghost,annoyed snake] contains m && get_property_int("_voteFreeFights") < 3)
    	return true;
    if (lookupMonsters("void guy,void slab,void spider") contains m && get_property_int("_voidFreeFights") < 5)
    	return true;
    if ($monsters[biker,burnout,jock,party girl,"plain" girl] contains m && get_property_int("_neverendingPartyFreeTurns") < 10)
    	return true;
    if (m == $monster[piranha plant]) //may or may not be location-specific?
    	return true;
    return false;
}

static
{
    int [location] __location_combat_rates;
}
void initialiseLocationCombatRates()
{
    if (__location_combat_rates.count() > 0)
        return;
    int [location] rates;
    file_to_map("data/combats.txt", __location_combat_rates);
    //needs spading:
    foreach l in $locations[the spooky forest]
        __location_combat_rates[l] = 85;
    __location_combat_rates[$location[the black forest]] = 95; //can't remember if this is correct
    __location_combat_rates[$location[inside the palindome]] = 80; //this is not accurate, there's probably a turn cap or something
    __location_combat_rates[$location[The Haunted Billiards Room]] = 85; //completely and absolutely wrong and unspaded; just here to make another script work
    foreach l in $locations[the haunted gallery, the haunted bathroom, the haunted ballroom]
        __location_combat_rates[l] = 90; //or 95? can't remember
    __location_combat_rates[$location[Twin Peak]] = 90; //FIXME assumption
    //print_html("__location_combat_rates = " + __location_combat_rates.to_json());
}
//initialiseLocationCombatRates();
int combatRateOfLocation(location l)
{
    initialiseLocationCombatRates();
    //Some revamps changed the combat rate; here we have some not-quite-true-but-close assumptions:
    if (l == $location[the haunted ballroom])
        return 95;
    if (__location_combat_rates contains l)
    {
        int rate = __location_combat_rates[l];
        if (rate < 0)
            rate = 100;
        return rate;
    }
    return 100; //Unknown
    
    /*float base_rate = l.appearance_rates()[$monster[none]];
    if (base_rate == 0.0)
        return 0;
    return base_rate + combat_rate_modifier();*/
}

//Specifically checks whether you can eat this item right now - fullness/drunkenness, meat, etc.
boolean CafeItemEdible(item it)
{
    //Mafia does not seem to support accessing its cafe data via ASH.
    //So, do the same thing. There's four mafia supports - Chez Snootee, Crimbo Cafe, Hell's Kitchen, and MicroBrewery.
    if (it.fullness > availableFullness())
        return false;
    if (it.inebriety > availableDrunkenness())
        return false;
    //FIXME rest
    if (it == $item[Jumbo Dr. Lucifer] && in_bad_moon() && my_meat() >= 150)
        return true;
    return false;
}

static
{
    int [string] __lta_social_capital_purchases;
    void initialiseLTASocialCapitalPurchases()
    {
        __lta_social_capital_purchases["bondAdv"] = 1;
        __lta_social_capital_purchases["bondBeach"] = 1;
        __lta_social_capital_purchases["bondBeat"] = 1;
        __lta_social_capital_purchases["bondBooze"] = 2;
        __lta_social_capital_purchases["bondBridge"] = 3;
        __lta_social_capital_purchases["bondDR"] = 1;
        __lta_social_capital_purchases["bondDesert"] = 5;
        __lta_social_capital_purchases["bondDrunk1"] = 2;
        __lta_social_capital_purchases["bondDrunk2"] = 3;
        __lta_social_capital_purchases["bondHP"] = 1;
        __lta_social_capital_purchases["bondHoney"] = 5;
        __lta_social_capital_purchases["bondInit"] = 1;
        __lta_social_capital_purchases["bondItem1"] = 1;
        __lta_social_capital_purchases["bondItem2"] = 2;
        __lta_social_capital_purchases["bondItem3"] = 4;
        __lta_social_capital_purchases["bondJetpack"] = 3;
        __lta_social_capital_purchases["bondMPregen"] = 3;
        __lta_social_capital_purchases["bondMartiniDelivery"] = 1;
        __lta_social_capital_purchases["bondMartiniPlus"] = 3;
        __lta_social_capital_purchases["bondMartiniTurn"] = 1;
        __lta_social_capital_purchases["bondMeat"] = 1;
        __lta_social_capital_purchases["bondMox1"] = 1;
        __lta_social_capital_purchases["bondMox2"] = 3;
        __lta_social_capital_purchases["bondMus1"] = 1;
        __lta_social_capital_purchases["bondMus2"] = 3;
        __lta_social_capital_purchases["bondMys1"] = 1;
        __lta_social_capital_purchases["bondMys2"] = 3;
        __lta_social_capital_purchases["bondSpleen"] = 4;
        __lta_social_capital_purchases["bondStat"] = 2;
        __lta_social_capital_purchases["bondStat2"] = 4;
        __lta_social_capital_purchases["bondStealth"] = 3;
        __lta_social_capital_purchases["bondStealth2"] = 4;
        __lta_social_capital_purchases["bondSymbols"] = 3;
        __lta_social_capital_purchases["bondWar"] = 3;
        __lta_social_capital_purchases["bondWeapon2"] = 3;
        __lta_social_capital_purchases["bondWpn"] = 1;
    }
    initialiseLTASocialCapitalPurchases();
}

int licenseToAdventureSocialCapitalAvailable()
{
    int total_social_capital = 0;
    total_social_capital += 1 + MIN(23, get_property_int("bondPoints"));
    foreach level in $ints[3,6,9,12,15]
    {
        if (my_level() >= level)
            total_social_capital += 1;
    }
    total_social_capital += 2 * get_property_int("bondVillainsDefeated");
    
    
    
    int social_capital_used = 0;
    foreach property_name, value in __lta_social_capital_purchases
    {
        if (get_property_boolean(property_name))
            social_capital_used += value;
    }
    //print_html("total_social_capital = " + total_social_capital + ", social_capital_used = " + social_capital_used);
    
    return total_social_capital - social_capital_used;
}



monster convertEncounterToMonster(string encounter)
{
    boolean [string] intergnat_strings;
    intergnat_strings[" WITH SCIENCE!"] = true;
    intergnat_strings["ELDRITCH HORROR "] = true;
    intergnat_strings[" WITH BACON!!!"] = true;
    intergnat_strings[" NAMED NEIL"] = true;
    intergnat_strings[" AND TESLA!"] = true;
    foreach s in intergnat_strings
    {
        if (encounter.contains_text(s))
            encounter = encounter.replace_string(s, "");
    }
    if (encounter == "The Junk") //not a junksprite
        return $monster[Junk];
    if ((encounter.stringHasPrefix("the ") || encounter.stringHasPrefix("The")) && encounter.to_monster() == $monster[none])
    {
        encounter = encounter.substring(4);
        //print_html("now \"" + encounter + "\"");
    }
    //if (encounter == "the X-32-F Combat Training Snowman")
        //return $monster[X-32-F Combat Training Snowman];
    if (encounter == "clingy pirate")
        return $monster[clingy pirate (male)]; //always accurate for my personal data
    return encounter.to_monster();
}

//Returns [0, 100]
float resistanceLevelToResistancePercent(float level)
{
	float m = 0;
	if (my_primestat() == $stat[mysticality])
		m = 5;
	if (level <= 3) return 10 * level + m;
    return 90 - 50 * powf(5.0 / 6.0, level - 4) + m;
}


//Mafia's text output doesn't handle very long strings with no spaces in them - they go horizontally past the text box. This is common for to_json()-types.
//So, add spaces every so often if we need them:
buffer processStringForPrinting(string str)
{
    buffer out;
    int limit = 50;
    int comma_limit = 25;
    int characters_since_space = 0;
    for i from 0 to str.length() - 1
    {
        if (str.length() == 0) break;
        string c = str.char_at(i);
        out.append(c);
        
        if (c == " ")
            characters_since_space = 0;
        else
        {
            characters_since_space++;
            if (characters_since_space >= limit || (c == "," && characters_since_space >= comma_limit)) //prefer adding spaces after a comma
            {
                characters_since_space = 0;
                out.append(" ");
            }
        }
    }
    return out;
}
void printSilent(string line, string font_colour)
{
    print_html("<font color=\"" + font_colour + "\">" + line.processStringForPrinting() + "</font>");
}

void printSilent(string line)
{
    print_html(line.processStringForPrinting());
}

//have_equipped() exists
boolean equipped(item it)
{
	return it.equipped_amount() > 0;
}

boolean have(item it)
{
	return it.available_amount() > 0;
}

boolean canAccessMall()
{
	if (!can_interact()) return false;
	if (!get_property_boolean("autoSatisfyWithMall")) return false;
	if (my_ascensions() == 0 && !get_property_ascension("lastDesertUnlock")) return false;
	return true;
}

string generateEquipmentLink(item equipment)
{
	if (!equipment.have()) return "";
	if (equipment.equipped()) return "inventory.php?which=2";
	
	string ftext_value = equipment.replace_string(" ", "+").entity_encode();
	if (equipment.item_amount() == 0 && can_interact() && equipment.storage_amount() > 0) return "storage.php?which=2&ftext=" + ftext_value;
	return "inventory.php?which=2&ftext=" + ftext_value;
}

//it says "next NC will be" but it means, extremely specifically, a certain class of non-combats. I don't know how this skill interacts with superlikelies or those intro adventures and such
boolean locationNextNCWillBeCartography(location l)
{
    if (!lookupSkill("Comprehensive Cartography").skill_is_usable()) return false;
    
    //We use the following method to determine if cartography will fire:
    //We look for "relevant" NC names in recent noncombats in the zone. If any of the relevant NCs are there, then it won't happen.
    //The relevant NCs are the cartography NC, and the NCs it "replaces"
    //This can fail, if there is five outside-zone data points in noncombat_queue - which I think can happen sometimes?
    boolean [string] relevant_nc_names;
 
	//manually handle every NC:
    if (l == $location[Guano Junction]) //100%
    {
        relevant_nc_names = $strings[The Hidden Junction];
    }
    else if (l == $location[A-boo Peak]) //...unknown? 100%?
    {
        relevant_nc_names = $strings[Ghostly Memories];
    }
    else if (l == $location[the haunted billiards room]) //not 100%
    {
        relevant_nc_names = $strings[Billiards Room Options,That's your cue,Welcome To Our ool Table];
    }
    else if (l == $location[The Dark Neck of the Woods]) //not 100%
    {
        relevant_nc_names = $strings[Your Neck of the Woods,How Do We Do It? Quaint and Curious Volume!,Strike One!,Olive My Love To You\, Oh.,Dodecahedrariffic!];
    }
    else if (l == $location[The Defiled Nook]) //not 100%
    {
        relevant_nc_names = $strings[No Nook Unknown,Skull\, Skull\, Skull];
    }
    else if (l == $location[The Castle in the Clouds in the Sky (Top Floor)]) //not 100%
    {
        relevant_nc_names = $strings[Here There Be Giants,Copper Feel,Melon Collie and the Infinite Lameness,Yeah\, You're for Me\, Punk Rock Giant,Flavor of a Raver];
    }
    else if (l == $location[A Mob of Zeppelin Protesters]) //not 100%
    {
        relevant_nc_names = $strings[Mob Maptality,Bench Warrant,Fire Up Above,This Looks Like a Good Bush for an Ambush];
    }
    else if (l == $location[Frat House]) //not 100%. FIXME correct zone?
    {
        relevant_nc_names = $strings[Oh Yeah!,Purple Hazers,From Stoked to Smoked,Murder by Death,Sing This Explosion to Me]; //is this correct...?
    }
    else if (l == $location[Wartime Frat House (Hippy Disguise)]) //not 100%. FIXME correct zone?
    {
        relevant_nc_names = $strings[Sneaky\, Sneaky,Catching Some Zetas,Fratacombs,One Less Room Than In That Movie];
    }
    else if (l == $location[Wartime Hippy Camp (Frat Disguise)]) //not 100%. FIXME correct zone?
    {
        relevant_nc_names = $strings[Sneaky\, Sneaky,Bait and Switch,Blockin' Out the Scenery,The Thin Tie-Dyed Line];
    }
    
    if (relevant_nc_names.count() == 0) return false;
    
    
    foreach key, noncombat_name in l.locationSeenNoncombats()
    {
        if (relevant_nc_names[noncombat_name]) return false;
    }
    return true;
}

string getBasicItemDescription(item it)
{
	buffer out;
	
	string item_type = it.item_type();
	
	//if (item_type == "accessory") item_type = "acc";
	if (item_type == "container") item_type = "back";
	int weapon_hands = it.weapon_hands();
	
	if (weapon_hands != 0)
	{
        stat weapon_type = it.weapon_type();
        
		out.append(weapon_hands);
        out.append("h ");
        if (weapon_type == $stat[moxie])
        	out.append("ranged ");
        else
        	out.append("melee ");
	}
	
	out.append(item_type);
	return out.to_string();
}

boolean monsterCanBeCopied(monster m)
{
	if (!m.copyable) return false;
	if (m.boss) return false;
	if ($monsters[writing desk,dirty thieving brigand] contains m) return false; //manual override list
	return true;
}

boolean locationIsGoneFromTheGame(location l)
{
	if (l.parent == "Removed") return true;
	
	return false;
}
boolean locationIsEventSpecific(location l)
{
	if (l.zone == "Twitch" || l.zone == "Events") return true;
	
	return false;
}


effect [skill] __skill_effect_override =
{
	$skill[Seal Clubbing Frenzy]:$effect[Seal Clubbing Frenzy],
	$skill[Patience of the Tortoise]:$effect[Patience of the Tortoise],
	$skill[Manicotti Meditation]:$effect[Pasta Oneness],
	$skill[Sauce Contemplation]:$effect[Saucemastery],
	$skill[Disco Aerobics]:$effect[Disco State of Mind],
	$skill[Moxie of the Mariachi]:$effect[Mariachi Mood]
};

//replacement for to_effect()
effect primaryEffectFromSkill(skill s)
{
    if (__skill_effect_override contains s)
        return __skill_effect_override[s];
    return s.to_effect();
}
boolean setting_only_show_macro_submitting = false; //my_id() == 2456416;
boolean __setting_helix_show_damage_choices = false;
boolean __setting_helix_show_damage_debug_regular_attack = false;
boolean __setting_helix_disable_minimal_use_staggers = true; //these add extremely minimal benefit outside of ronin, and sometimes even in, and take *forever* because KOL's server is slooow

monster __m;
string __page_text;


boolean [string] __monster_attributes;
int [string] __monster_attributes_int;
float [string] __monster_attributes_float;
string [string] __monster_attributes_string;
element [string] __monster_attributes_elements;
boolean [string] __monster_one_crazy_random_summer_modifiers;

string __helix_fossil_version = "1.1.7";


boolean [skill] __abort_on_using_skill = $skills[suckerpunch];
boolean [skill] __ignore_these_skills;
//import "scripts/Helix Fossil/Helix Fossil/Pocket Familiars Alternate Algorithm.ash";

int POCKET_FAMILIAR_OWNER_TYPE_UNKNOWN = 0;
int POCKET_FAMILIAR_OWNER_TYPE_OURS = 1;
int POCKET_FAMILIAR_OWNER_TYPE_OPPONENTS = 2;
Record PocketFamiliar
{
	familiar f;
	string familiar_name_raw;
	int level;
	string name;
	int attack;
	int hp;
	int max_hp;
	int defence;
	boolean [string] moves;
	boolean [string] usable_moves;
	string [int] move_ordering;
	string [string] usable_moves_mapping;
	string [string] move_descriptions;
	boolean [string] special_attributes;
	boolean knocked_out;
	boolean effectively_knocked_out; //they'll die because of poison
	int owner;
	
	string next_round_chosen_enemy_move;
};

Record PocketFamiliarFightStatus
{
	PocketFamiliar [int] player_familiars;
    PocketFamiliar [int] monster_familiars;
    monster m;
    string monster_name_raw;
};

PocketFamiliarFightStatus __pocket_familiar_fight_status;

PocketFamiliar PocketFamiliarParseFamiliarFromText(string table_text)
{
	PocketFamiliar f;
	
	
        
    string [int][int] level_familiar_info = table_text.group_string("<Td class=tiny>Lv. ([0-9]+) (.*?)</td>");
    
    string [int][int] move_buttons = table_text.group_string("<input (.*?)>");
    
    
    string [int][int] enemy_move_buttons = table_text.group_string("<span title=\"(.*?)\">\\[(.*?)\\]</span>");
    
    string attributes_area = table_text.group_string("<td rowspan=2 align=center width=60>(.*?)</td>")[0][1];
    string [int][int] attributes_matches = attributes_area.group_string("<img .*? alt=\"(.*?)\"");
	
    if (table_text.contains_text("='knockedout' ><tr><td rowspan=2>"))
    {
        f.knocked_out = true;
        f.effectively_knocked_out = true;
    }
    f.f = level_familiar_info[0][2].to_familiar();
    f.familiar_name_raw = level_familiar_info[0][2];
    f.level = level_familiar_info[0][1].to_int();
    f.name = "";
    f.attack = table_text.group_string("blacksword.gif").count();
    f.hp = table_text.group_string("blackheart.gif").count();
    f.max_hp = f.hp + table_text.group_string("candyheart.gif").count();
    
    f.defence = table_text.group_string("whiteshield.gif").count();
    
    foreach key in move_buttons
    {
        string html = move_buttons[key][0];
        //title=\"(.*?)\".*?value=\"(.*?)\" name=\"(.*?)\"
        string description = html.group_string("title=\"(.*?)\"")[0][1];
        string name = html.group_string("value=\"(.*?)\"")[0][1];
        if (name == "")
            name = html.group_string("value='(.*?)'")[0][1];
        if (name == "")
            name = html.group_string("value=(.*?) ")[0][1];
        string submit = html.group_string("name=\"(.*?)\"")[0][1];
        if (submit == "")
            submit = html.group_string("name='(.*?)' ")[0][1];
        if (submit == "pwd") continue;
        boolean disabled = html.contains_text(" disable style=");
        
        f.moves[name] = true;
        f.move_ordering.listAppend(name);
        if (!disabled)
        {
            f.usable_moves[name] = true;
             f.usable_moves_mapping[name] = submit;
        }
        f.move_descriptions[name] = description;
    }
    foreach key in enemy_move_buttons
    {
        string description = enemy_move_buttons[key][1];
        string name = enemy_move_buttons[key][2];
        f.moves[name] = true;
        f.usable_moves[name] = true;
        f.move_descriptions[name] = description;
        if (enemy_move_buttons[key][0].contains_text("This is what the enemy team will do next round"))
            f.next_round_chosen_enemy_move = name;
    }
    foreach key in attributes_matches
    {
        string attribute = attributes_matches[key][1];
        if (attribute.contains_text(":"))
            attribute = attribute.substring(0, attribute.index_of(":"));
        f.special_attributes[attribute] = true;
    }
    if (move_buttons.count() > 0)
    {
        f.owner = POCKET_FAMILIAR_OWNER_TYPE_OURS;
    }
    if (enemy_move_buttons.count() > 0)
    {
        f.owner = POCKET_FAMILIAR_OWNER_TYPE_OPPONENTS;
    }
    //They're effectively dead if they're poisoned and at one HP; cannot save them.
    if (f.special_attributes["Poisoned"] && f.hp == 1)
    	f.effectively_knocked_out = true;
    return f;
}

PocketFamiliarFightStatus PocketFamiliarsParsePage(buffer page_text)
{
	PocketFamiliarFightStatus status;
    if (!page_text.contains_text(">Fight!</b></td></tr>"))
        return status;
	string [int][int] table_matches = page_text.group_string("<table class(.*?)</table>");
	
 	status.monster_name_raw = page_text.group_string("<b[^>]*><center>(.*?)'s Team:</b>")[0][1];
	status.m = convertEncounterToMonster(status.monster_name_raw);
	
	foreach key in table_matches
	{
        string table_text = table_matches[key][1];
        
        //Extract information:
        PocketFamiliar f = PocketFamiliarParseFamiliarFromText(table_text);
        
        
        
        if (f.owner == POCKET_FAMILIAR_OWNER_TYPE_OURS)
        {
        	status.player_familiars[status.player_familiars.count()] = f;
        }
        if (f.owner == POCKET_FAMILIAR_OWNER_TYPE_OPPONENTS)
        {
            status.monster_familiars[status.monster_familiars.count()] = f;
        }
        string newline_text = "<br>&nbsp;&nbsp;&nbsp;&nbsp;";
	}
	//Reverse status.monster_familiars:
	PocketFamiliar [int] new_opponent_familiars;
	foreach key, f in status.monster_familiars
	{
		new_opponent_familiars[status.monster_familiars.count() - 1 - key] = f;
	}
	status.monster_familiars = new_opponent_familiars;
	if (my_id() == 1557284)
		logprint("POKEMON_FIGHT_STATUS: " + status.to_json());
	__pocket_familiar_fight_status = status;
	return status;
}


int POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_UNKNOWN = 0;
int POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST = 1;
int POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_REARMOST = 2;
int POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_RANDOM_INDIVIDUAL = 3;
int POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_RANDOM_MULTIPLE = 4;
int POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_ALL = 5;
int POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_DISTRIBUTED = 6;
Record PocketFamiliarMoveStats
{
	int total_damage_done;
	int total_healed;
	int total_enemy_attack_reduction;
	int total_our_attack_increase;
	int total_damage_avoided;
	boolean [string] enemy_attributes;
	int affects_type;
	boolean is_ultimate_move;
};

//FIXME a better method: calculate every possible state that exists after executing the opponent's moves and our moves.
PocketFamiliarMoveStats PocketFamiliarCalculateMoveStats(string move, PocketFamiliar move_familiar, PocketFamiliar [int] our_familiars, PocketFamiliar [int] opponents_familiars)
{
	//This is moderately broken.
	PocketFamiliarMoveStats stats;
	
    PocketFamiliarMoveStats enemy_move_stats;
	foreach key, opponent_familiar in opponents_familiars
	{
		if (opponent_familiar.next_round_chosen_enemy_move != "")
        {
        	enemy_move_stats = PocketFamiliarCalculateMoveStats(opponent_familiar.next_round_chosen_enemy_move, opponent_familiar, opponents_familiars, our_familiars);
            break;
        }
	}
	
	if (move == "Laser Beam")
	{
		//Deal 2 damage to a random enemy.
        stats.total_damage_done = 2;
	}
	else if (move == "Sting")
	{
		//Deal [power] damage to the frontmost enemy and poison it.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST;
        stats.total_damage_done = move_familiar.attack;
        stats.enemy_attributes["poison"] = true;
	}
	else if (move == "Stinkblast")
	{
		//Deal 1 damage to a random enemy and poison it
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_RANDOM_INDIVIDUAL;
        stats.total_damage_done = 1;
        stats.enemy_attributes["poison"] = true;
	}
	else if (move == "Bonk" || move == "Peck")
	{
		//Deal [power] damage to the frontmost enemy.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST;
        stats.total_damage_done = move_familiar.attack;
	}
	else if (move == "Punch")
	{
		//Deal [power] damage to the frontmost enemy and reduce its power by 1.
        //FIXME track power reduction
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST;
        stats.total_damage_done = move_familiar.attack;
        stats.total_enemy_attack_reduction = 1;
	}
    else if (move == "Claw")
    {
        //Deal [power] damage to the frontmost enemy and 1 damage to a random enemy.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST; //not quite right, but...
        stats.total_damage_done = move_familiar.attack;
        int enemy_familiars_around = 0;
        foreach key, enemy_familiar in opponents_familiars
        {
            if (enemy_familiar.effectively_knocked_out)
                 continue;
            enemy_familiars_around += 1;
        }
        //FIXME this is not correct, but claw is bugged?
        if (enemy_familiars_around > 1)
        	stats.total_damage_done += 1;
    }
    else if (move == "Bite")
    {
    	//Deal [power] damage to a random enemy.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_RANDOM_INDIVIDUAL;
        stats.total_damage_done = move_familiar.attack;
    }
    else if (move == "Howl" || move == "Breathe Fire")
    {
        //Deal 1 damage to all enemies.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_ALL;
        foreach key, enemy_familiar in opponents_familiars
        {
            if (enemy_familiar.effectively_knocked_out)
                 continue;
        	stats.total_damage_done += 1;
        }
    }
    else if (move == "Encourage")
    {
    	stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST;
        stats.total_our_attack_increase += 1;
    }
    else if (move == "Growl")
    {
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_RANDOM_MULTIPLE;
        
        foreach key, enemy_familiar in opponents_familiars
        {
            if (enemy_familiar.effectively_knocked_out)
                 continue;
			if (enemy_familiar.attack > 1)
				stats.total_enemy_attack_reduction += 1;
            if (stats.total_enemy_attack_reduction == 2)
            	break;
        }
    }
    else if (move == "Splash")
    {
        //Deal 1 damage to two random enemies.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_RANDOM_MULTIPLE;
        foreach key, enemy_familiar in opponents_familiars
        {
            if (enemy_familiar.effectively_knocked_out)
                 continue;
            stats.total_damage_done += 1;
            if (stats.total_damage_done == 2)
            	break;
        }
    }
    else if (move == "ULTIMATE: Deluxe Impale")
    {
    	//Deal 5 damage to the frontmost enemy.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST;
        stats.total_damage_done = 5;
        stats.is_ultimate_move = true;
    }
    else if (move == "ULTIMATE: Spiky Burst")
    {
        //Deals 8 damage spread out among all foes randomly.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_DISTRIBUTED;
        stats.total_damage_done = 8;
        stats.is_ultimate_move = true;
    }
    else if (move == "ULTIMATE: Blood Bath")
    {
        //???
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_DISTRIBUTED;
        stats.total_damage_done = 12;
        stats.is_ultimate_move = true;
    }
    else if (move == "ULTIMATE: Nuclear Bomb")
    {
    	//Deal 5 damage to the rearmost enemy
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_REARMOST;
        stats.total_damage_done = 5;
        stats.is_ultimate_move = true;
    }
    else if (move == "ULTIMATE: Violent Shred")
    {
        //Deals 2 damage to all enemies.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_ALL;
        foreach key, enemy_familiar in opponents_familiars
        {
            if (enemy_familiar.effectively_knocked_out)
                 continue;
            stats.total_damage_done += MIN(enemy_familiar.hp, 2);
        }
    }
    /*else if (move == "Swoop")
    {
    	//Avoid all attack damage this turn.
        //addendum: only this familiar...?
    	stats.total_damage_avoided = enemy_move_stats.total_damage_done;
    }*/
    else if (move == "Hug")
    {
    	//Heal the frontmost ally by [power]
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST;
        stats.total_healed = 10000; //will auto-clamp
    }
    else if (move == "Regrow")
    {
        //Heal the frontmost ally by [power]
        //stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST;
        stats.total_healed = MIN((move_familiar.max_hp - move_familiar.hp), move_familiar.attack); //will auto-clamp
    }
    else if (move == "Backstab")
    {
    	//Deal 1 damage to the rearmost enemy and poison it.
        stats.affects_type = POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_REARMOST;
        stats.total_damage_done = 1;
        stats.enemy_attributes["poison"] = true;
    }
    else if (move == "Rest")
    {
    	//Recover other moves
    }
    else if (move == "Retreat")
    {
        //Move to...?
    }
	else
	{
    	if (my_id() == 1557284)
			printSilent("Unknown move " + move + " - " + move_familiar.move_descriptions[move], "#FF3333");
	}
	
	//Cap total damage done and total hp restored:
	//FIXME this is incomplete
	if (stats.affects_type == POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_FRONTMOST)
	{
        if (stats.total_damage_done > 0)
        {
        	PocketFamiliar frontmost_enemy_familiar;
            foreach key, enemy_familiar in opponents_familiars
            {
            	if (enemy_familiar.effectively_knocked_out)
             		continue;
                frontmost_enemy_familiar = enemy_familiar;
                break;
            }
            
            stats.total_damage_done = MIN(frontmost_enemy_familiar.hp, stats.total_damage_done);
            if (frontmost_enemy_familiar.special_attributes["Regenerating"] && frontmost_enemy_familiar.hp > 1)
            {
            	//FIXME do regen correction against REAR
            	stats.total_damage_done -= 1;
            }
        }
        if (stats.total_healed > 0)
        {
            PocketFamiliar frontmost_our_familiar;
            foreach key, our_familiar in our_familiars
            {
                if (our_familiar.effectively_knocked_out)
                     continue;
                frontmost_our_familiar = our_familiar;
                break;
            }
            stats.total_healed = MIN(stats.total_healed, frontmost_our_familiar.max_hp - frontmost_our_familiar.hp);
        }
        if (stats.total_enemy_attack_reduction > 0)
        {
        	
        }
        if (stats.enemy_attributes["poison"])
        {
            PocketFamiliar frontmost_enemy_familiar;
            foreach key, enemy_familiar in opponents_familiars
            {
                if (enemy_familiar.effectively_knocked_out)
                     continue;
                frontmost_enemy_familiar = enemy_familiar;
                break;
            }
            if (frontmost_enemy_familiar.special_attributes["Poisoned"])
                remove stats.enemy_attributes["poison"];
        }
	}
	if (stats.affects_type == POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_REARMOST)
	{
		if (stats.enemy_attributes["poison"])
        {
            PocketFamiliar rearmost_enemy_familiar;
            foreach key, enemy_familiar in opponents_familiars
            {
                if (enemy_familiar.effectively_knocked_out)
                     continue;
                rearmost_enemy_familiar = enemy_familiar;
            }
            if (rearmost_enemy_familiar.special_attributes["Poisoned"])
            	remove stats.enemy_attributes["poison"];
        }
	}
    if (stats.affects_type == POCKET_FAMILIAR_MOVE_AFFECTS_TYPE_RANDOM_INDIVIDUAL)
    {
    	//FIXME if all are poisoned, don't
        if (stats.total_damage_done > 0)
        {
            int maximum_enemy_hp = 0;
            boolean all_have_regenerate = true;
            foreach key, enemy_familiar in opponents_familiars
            {
                if (enemy_familiar.effectively_knocked_out)
                     continue;
                maximum_enemy_hp = MAX(enemy_familiar.hp, maximum_enemy_hp);
                if (!enemy_familiar.special_attributes["Regenerating"])
                	all_have_regenerate = false;
            }
            stats.total_damage_done = MIN(maximum_enemy_hp, stats.total_damage_done);
            if (all_have_regenerate)
            	stats.total_damage_done = MAX(0, stats.total_damage_done - 1);
        }
    }
	
	return stats;
}

buffer PocketFamiliarsFightRound(buffer page_text)
{
    if (!page_text.contains_text(">Fight!</b></td></tr>"))
    {
        return page_text;
    }
    PocketFamiliarFightStatus status = PocketFamiliarsParsePage(page_text);
    string chosen_move_name;
    string chosen_move_submit;
    
    
    float [string] universal_move_priority;
    universal_move_priority["Rest"] = 1000;
    universal_move_priority["Retreat"] = 10000;
    universal_move_priority["Tackle"] = 10000; //Knock the frontmost enemy to the back.
    universal_move_priority["ULTIMATE: Healing Rain"] = -10000; //very useful. FIXME situation don't do if we won't gain regeneration
    universal_move_priority["ULTIMATE: Empowering Cheer"] = -10000; //Give all allies +1 Power.
    universal_move_priority["ULTIMATE: Nasty Cloud"] = -1000.0; //Poison all enemies
    if (false)
    {
    	//Pick a random move and use it:
        //Wait, no. Use a priority system.
        
        float [string] approximate_move_priority;
        
        approximate_move_priority["Growl"] = 100; //FIXME test
        approximate_move_priority["Armor Up"] = 100; //FIXME test
        approximate_move_priority["Embarrass"] = 100; //FIXME test
        
        foreach move, value in universal_move_priority
        	approximate_move_priority[move] = approximate_move_priority[move] + value;
        
    	string [int] usable_moves_submit;
        string [string] inverse_mapping;
        foreach key, f in status.player_familiars
        {
        	foreach move_name, move_submit in f.usable_moves_mapping
            {
            	usable_moves_submit.listAppend(move_submit);
             	inverse_mapping[move_submit] = move_name;
              
                //PocketFamiliarMoveStats stats = PocketFamiliarCalculateMoveStats(move_name, f, status.player_familiars, status.monster_familiars);
                
            }
        }
        sort usable_moves_submit by approximate_move_priority[inverse_mapping[value]];
        chosen_move_submit = usable_moves_submit[0]; //.listGetRandomObject();
        chosen_move_name = inverse_mapping[chosen_move_submit]; 
        //abort("usable_moves_submit = " + usable_moves_submit.to_json() + ", chosen_move_submit = " + chosen_move_submit); 
    }
    else if (true)
    {
    	//Pick good moves:
        //It's easy. Just ignore all the bad ones.
        //Possible situation to handle: do a healing move if the next attack will kill our familiar, but only if it works?
        Record MoveSelection
        {
        	string name;
            string submit_value;
            float priority;
        };
        
        
        float damage_multiplier = -100.0;
        float damage_avoided_multiplier = -200.0; //just slightly better; avoiding three damage is better than doing two.
        float heal_multiplier = -10.0;
        float total_attack_reduction_multiplier = -1.0;
        float total_attack_increase_multiplier = -2.0;
        
        
        MoveSelection [int] selections;
        foreach key, f in status.player_familiars
        {
            foreach move_name, move_submit in f.usable_moves_mapping
            {
            	MoveSelection move;
                move.name = move_name;
                move.submit_value = move_submit;
                PocketFamiliarMoveStats stats = PocketFamiliarCalculateMoveStats(move_name, f, status.player_familiars, status.monster_familiars);
                move.priority += stats.total_damage_done * damage_multiplier;
                move.priority += stats.total_healed * heal_multiplier;
                move.priority += universal_move_priority[move_name];
                move.priority += stats.total_damage_avoided * damage_avoided_multiplier;
                move.priority += stats.total_enemy_attack_reduction * total_attack_reduction_multiplier;
                move.priority += stats.total_our_attack_increase * total_attack_increase_multiplier;
                if (stats.enemy_attributes["poison"])
                	move.priority += 2 * damage_multiplier; //FIXME maximum health, etc
            	if (stats.is_ultimate_move)
             		move.priority += 1; //resolve ties to avoid ultimate moves until we need them. like, if your ultimate move deals five damage to the front row, you probably shouldn't use it on an enemy with one HP.
            	selections[selections.count()] = move;
            }
        }
        sort selections by value.priority;
        
        chosen_move_submit = selections[0].submit_value;
        chosen_move_name = selections[0].name; 
    }
    
    if (chosen_move_submit != "")
    {
    	//fambattle.php?pwd&famaction[splash-108]=Splash
    	print("Attacking with " + chosen_move_name);
        //abort("");
        return visit_url("fambattle.php?" + chosen_move_submit + "=" + chosen_move_name);
    }
    else
    {
    	abort("Unable to choose a move.");
    }
    
    buffer blank;
    return blank;
}

buffer PocketFamiliarsFight(boolean from_relay)
{
	int breakout = 100;
	boolean fight_finished = false;
    buffer page_text = visit_url("fambattle.php");
	while (breakout > 0)
	{
		breakout -= 1;
        page_text = PocketFamiliarsFightRound(page_text);
        if (!page_text.contains_text(">Fight!</b></td></tr>"))
        	break;
        if (page_text.contains_text("<!--WINWINWIN-->"))
        {
        	fight_finished = true;
            print("Winner!");
            break;
        }
        if (page_text.contains_text("You slink away, dejected and defeated."))
        {
        	fight_finished = true;
        	print("We lost!");
            if (!from_relay)
	            abort("We lost, stopping.");
            break;
        }
    }
    if (breakout <= 0 && !fight_finished)
    	abort("Fight didn't finish?");
    return page_text;
}

buffer PocketFamiliarsFight()
{
	return PocketFamiliarsFight(false);
}


void main()
{
	PocketFamiliarsFight();
}