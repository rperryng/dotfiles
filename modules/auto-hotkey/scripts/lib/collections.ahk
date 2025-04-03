#Requires AutoHotkey v2.0

; IsItemInList
; Checks if an item is in a list
; @param item The item to check
; @param list The list to check
; @param del The delimiter used in the list
; @return True if the item is in the list, false otherwise
IsItemInList(item, list, delimiter:=",")
{
	If IsObject(list){
		for k,v in list
			if (v=item)
				return true
		return false
	} else Return !!InStr(delimiter list delimiter, delimiter item delimiter)
}
