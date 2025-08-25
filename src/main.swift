//
//  main.swift
//  IP Lookup
//
//  Created by Reza on 2/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation


//optimize bucket Sort

func bucketSort(items:[IP])->[IP] {
    
    var buckets=[[IP]]()
    
    for _ in 0...32 {
        let temp=[IP]()
        buckets.append(temp)
    }
    
    for i in 0..<items.count {
        print("sorting:\(i)form:\(items.count)")
        let length=items[i].length!
        if length>=0 && length<=32 {
            buckets[length].append(items[i])
        }
    }
    
    var sortedIPs=[IP]()
    
    for i in 0..<buckets.count {
        for j in 0..<buckets[i].count {
            sortedIPs.append(buckets[i][j])
        }
    }
    
    
    return sortedIPs
   

}


func bubbleSort(items:[IP]){
    var sortedAboveIndex = items.count
    repeat {
        var lastSwapIndex = 0
        for i in 1..<sortedAboveIndex {
            print("sort:\(i),from:\(sortedAboveIndex)")
            
            if items[i-1].length! > items[i].length! {
                swapItem(items: items, itemAtIndex: i, withItemAtIndex: i-1)
                lastSwapIndex = i
                
            }
        }
        sortedAboveIndex = lastSwapIndex
        
    } while (sortedAboveIndex != 0)
    
}
func swapItem(items:[IP],itemAtIndex i:Int,withItemAtIndex j:Int) {
    
    let temp=IP();
    
    temp.length=items[i].length
    temp.rawIP=items[i].rawIP
    temp.destIP=items[i].destIP
    temp.prefix=items[i].prefix
    temp.hash=items[i].hash
    temp.bmp=items[i].bmp
    temp.isPrefix=items[i].isPrefix
    temp.isMarker=items[i].isMarker
    
    
    items[i].length=items[j].length
    items[i].rawIP=items[j].rawIP
    items[i].destIP=items[j].destIP
    items[i].prefix=items[j].prefix
    items[i].hash=items[j].hash
    items[i].bmp=items[j].bmp
    items[i].isPrefix=items[j].isPrefix
    items[i].isMarker=items[j].isMarker
    
    
    items[j].length=temp.length
    items[j].rawIP=temp.rawIP
    items[j].destIP=temp.destIP
    items[j].prefix=temp.prefix
    items[j].hash=temp.hash
    items[j].bmp=temp.bmp
    items[j].isPrefix=temp.isPrefix
    items[j].isMarker=temp.isMarker
    
    
    
}



//Binary String

func returnBinaryString(num:Int)->String {
    let str = String(num, radix: 2)
    return pad(string: str, toSize: 8)
    
}

func pad(string : String, toSize: Int) -> String {
    var padded = string
    for _ in 0..<(toSize - string.characters.count) {
        padded = "0" + padded
    }
    return padded
}

//

func searchHash(prefix:String,list:[IP])->Int? {
    let hash=prefix.hash
    
    for i in 0..<list.count {
        if list[i].hash == hash {
            return i
        }
    }
    
    return nil
}


//Function BuildBasic;
func BuildBasicForLinearSearch(list: [IP])->[PrefixTableCell] {
    
    var lastReadLength=list[0].length
    var prefixTable=[PrefixTableCell]()
    var lastIndexHash=[IP]()
    for i in 0..<list.count {
        
        
//        print("build:\(i),from:\(list.count)")
        
        
        if list[i].length==lastReadLength {
            lastIndexHash.append(list[i])
        } else {
            let temp=PrefixTableCell()
            temp.length=lastReadLength
            temp.IPs=lastIndexHash
            prefixTable.append(temp)
            
            lastReadLength=list[i].length
            lastIndexHash=[]
            lastIndexHash.append(list[i])
            
        }
        
    }
    
    let temp=PrefixTableCell()
    temp.length=lastReadLength
    temp.IPs=lastIndexHash
    prefixTable.append(temp)
    
    
    return prefixTable
    
}


func linearSearch(prefixTable:[PrefixTableCell],forPrefix:String,prefixLength:Int)->String {
    var BMP=""
    
    var i=prefixTable.count-1
    
    while i>=0 {
        
        if prefixTable[i].length!<=prefixLength {
            
            let nSTempPrefix=NSString(string: forPrefix)
            let tempPrefix=nSTempPrefix.substring(to:prefixTable[i].length!)
            
            let entry_Id=searchHash(prefix: tempPrefix, list: prefixTable[i].IPs!)
            
            if entry_Id != nil {
                BMP=prefixTable[i].IPs![entry_Id!].prefix!
                break
            }
            
        }
        
        i-=1
        
    }
    
    return BMP
    
    
    
}


//Figure 6: Binary Search

func binarySearch(seedPrefixTable:[PrefixTableCell],forPrefix:String,prefixLength:Int)->String {
    
    
    //Initialize search range R to cover the whole array L;
    
    var R=[PrefixTableCell]()
    
    for i in 0..<seedPrefixTable.count {
        if seedPrefixTable[i].length! <= prefixLength {
            R.append(seedPrefixTable[i])
        }
    }
    
    //Initialize B M P found so far to null string;
    var BMP=""
    
    //While R is not empty do
    while R.count>0 {
        
        
        //Let i correspond to the middle level in range R;
        let i = R.count/2
        
        
        //Extract the first L[i].length bits of userPrefix into tempPrefix;
        let nSTempPrefix=NSString(string: forPrefix)
        let tempPrefix=nSTempPrefix.substring(to:R[i].length!)
        
        //M := Search(tempPrefix , L[i].hash)
        let M_Id=searchHash(prefix: tempPrefix, list: R[i].IPs!)
        
        //If M is nil Then set R := upper half of R;
        if M_Id==nil {
            for _ in i..<R.count {
                R.remove(at: i)
            }
            
            
        } else {
            
            let M=R[i].IPs![M_Id!]
            
            //Elseif M is a prefix and not a marker
            if M.isPrefix && !M.isMarker {
                
                //Then BMP=M.bmp;
                BMP=M.bmp
                
                
                // break;
                break
                
            } else {
                //Else
                
                //BMP=M.bmp;
                BMP=M.bmp
                
                 //R := lower half of R;
                for _ in 0...i {
                    R.remove(at: 0)
                    
                }
                
            }
        }

    }
    
    
    return BMP
    
    
}



//Function BuildBasic;
func BuildBasic(list: [IP])->[PrefixTableCell] {
    
    var lastReadLength=list[0].length
    var prefixTable=[PrefixTableCell]()
    var lastIndexHash=[IP]()
    for i in 0..<list.count {
        
        //Use Basic Algorithm on what has been built by now to find the BMP of Prefix and store it in BMP ;
        

        print("build:\(i),from:\(list.count)")

        
        list[i].bmp=list[i].prefix!
        let BMP=binarySearch(seedPrefixTable: prefixTable, forPrefix: list[i].prefix!, prefixLength: list[i].length!)
        
        if list[i].length==lastReadLength {
            lastIndexHash.append(list[i])
        } else {
            let temp=PrefixTableCell()
            temp.length=lastReadLength
            temp.IPs=lastIndexHash
            prefixTable.append(temp)
            
            lastReadLength=list[i].length
            lastIndexHash=[]
            lastIndexHash.append(list[i])
            
        }
        
        //(* Now insert all necessary markers “above” *)
        
        var j=prefixTable.count-1
        while j>=0 {
            
            //Shorten Prefix to Leng th bits;
            let nSMarkerPrefix=NSString(string: list[i].prefix!)
            let markerPrefix=nSMarkerPrefix.substring(to:prefixTable[j].length!)

            let entryId=searchHash(prefix: markerPrefix, list: prefixTable[j].IPs!)
            
            if entryId != nil {
                let entry=prefixTable[j].IPs![entryId!]
                entry.isMarker=true
                break
            } else {
                let marker = IP()
                marker.length=prefixTable[j].length!
                marker.prefix=markerPrefix
                marker.hash=markerPrefix.hash
                marker.isMarker=true
                marker.bmp = BMP
                prefixTable[j].IPs!.append(marker)
                
            }
            
            j-=1
        }
        
    }
    
    let temp=PrefixTableCell()
    temp.length=lastReadLength
    temp.IPs=lastIndexHash
    prefixTable.append(temp)
    
    
    return prefixTable
    
}


func save(prefixTable:[PrefixTableCell],inURL url:URL){
    var file=""
    for i in 0..<prefixTable.count {
        file+="\(prefixTable[i].length!)"
        
        for j in 0..<prefixTable[i].IPs!.count {
            
            //Seprate length of cell and IPs of Cell and also seprate each IP of IPs by "$"
            file+="$"
            let ipToSave=prefixTable[i].IPs![j]
            
            //save attributes of IP
            
            file+="\(ipToSave.length!)"
            
            //Seprate attributes of IP by ","
            file+=","
            
            if ipToSave.rawIP != nil {
                file+=ipToSave.rawIP!
            } else {
                file+="nil"
            }
            
            file+=","
            
            if ipToSave.destIP != nil {
                file+=ipToSave.destIP!
            } else {
                file+="nil"
            }
            
            file+=","
            
            file+="\(ipToSave.prefix!)"
            
            file+=","
            
            file+="\(ipToSave.hash!)"
            
            file+=","
            
            file+="\(ipToSave.bmp)"
            
            file+=","
            
            if ipToSave.isPrefix {
                file+="t"
            } else {
                file+="f"
            }
            
            file+=","
            
            if ipToSave.isMarker {
                file+="t"
            } else {
                file+="f"
            }
            
        }
        //Seprate prefixTable cells by "\n"
        if i != prefixTable.count-1 {
            file+="\n"
        }
        
    }
    try! file.write(to: url, atomically: false, encoding: String.Encoding.utf8)
    
    print("saved!")
    
}

func load(fromURL url:URL) -> [PrefixTableCell] {
    
    var prefixTable=[PrefixTableCell]()
    let text=try! String(contentsOf: url, encoding: String.Encoding.utf8)
    
    let tableCellsText=text.components(separatedBy: "\n")
    
    for i in 0..<tableCellsText.count {
        
        let prefixTableCell=PrefixTableCell()
        
        let cellComponents=tableCellsText[i].components(separatedBy: "$")
        prefixTableCell.length=Int(cellComponents[0])
        
        var cell_IPs=[IP]()
        
        for j in 1..<cellComponents.count {
            let tempIP=IP()
            let ipComponents=cellComponents[j].components(separatedBy: ",")
            
            //load attributes of IP
            
            tempIP.length=Int(ipComponents[0])
            
            if ipComponents[1] != "nil" {
                tempIP.rawIP=ipComponents[1]
            }
            
            if ipComponents[2] != "nil" {
                tempIP.destIP=ipComponents[2]
            }
            
            tempIP.prefix=ipComponents[3]
            
            tempIP.hash=Int(ipComponents[4])
            
            tempIP.bmp=ipComponents[5]
            
            if ipComponents[6] == "t" {
                tempIP.isPrefix=true
            }
            
            if ipComponents[7] == "t" {
                tempIP.isMarker=true
            }
            
            cell_IPs.append(tempIP)
            
        }
        
        prefixTableCell.IPs=cell_IPs
        
        prefixTable.append(prefixTableCell)
    }
    
    print("loaded")
    
    return prefixTable
    
}

//Start ---------------------------------------------------------------


// #time
var startTime=clock()

//URLs

let file = "table1.txt"
let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
let data_url = urls[urls.count-1].appendingPathComponent(file)


let saveName="saveFile.save"
let saveURL=urls[urls.count-1].appendingPathComponent(saveName)


//Load Data From Data Base

let text=try! String(contentsOf: data_url, encoding: String.Encoding.utf8)
let rawIPs=text.components(separatedBy: "\n")

var IPs=[IP]()

for i in 0..<rawIPs.count {
    let temp=IP()
    let comp=rawIPs[i].components(separatedBy: "\\")
    temp.rawIP=comp[0]
    temp.length=Int(comp[1].components(separatedBy: " ")[0])
    temp.destIP=comp[1].components(separatedBy: " ")[1]
    
    let subIps=comp[0].components(separatedBy: ".")
    var BinaryIP=""
    for j in 0..<subIps.count {
        let tempSub=Int(subIps[j])
        BinaryIP+=returnBinaryString(num: tempSub!)
    }
    
    let nSPrefix=NSString(string: BinaryIP)
    temp.prefix=nSPrefix.substring(to:temp.length!)
    
    temp.hash=temp.prefix?.hash
    
    temp.isPrefix=true
    
    
    IPs.append(temp)
}

var trimmedIP=[IP]()
var interval=8

for i in 0..<IPs.count {
    if i % interval == 0 {
        trimmedIP.append(IPs[i])
    }
}

var sort_startTime=clock()

let sortedIPs=bucketSort(items: trimmedIP)

var sort_endTime=clock()
let sortTime=sort_endTime-sort_startTime
print("Sort Time:\(Double(sortTime)/Double(CLOCKS_PER_SEC))")

//Build -----------------------------------------------


//Linear ------------
//let prefixTable = BuildBasicForLinearSearch(list: sortedIPs)
//save(prefixTable: prefixTable,inURL:saveURL)


//Binary ------------

let prefixTable=BuildBasic(list: sortedIPs)
save(prefixTable: prefixTable,inURL:saveURL)


//load From Save File -----------------------------------------

//let prefixTable=load(fromURL: saveURL)


// #time
var endTime=clock()


// #time
let buildTime=endTime-startTime
print("Build Time:\(Double(buildTime)/Double(CLOCKS_PER_SEC))")

while(true) {

    print("please write an IP: (example 192.168.4.10)\n")
    var userIP = readLine()
    
    
    print("please write prefix: (example: 30 )\n")
    var prefixLengthString = readLine()
    var prefixLength:Int? = nil
    if prefixLengthString != nil {
        prefixLength=Int(prefixLengthString!)
    }
    
    
    if userIP != nil && prefixLength != nil {
        
        // #time
        startTime=clock()
        
        
        //Make UserIP Binary
        let subIps=userIP!.components(separatedBy: ".")
        var BinaryIP=""
        for i in 0..<subIps.count {
            let tempSub=Int(subIps[i])
            BinaryIP+=returnBinaryString(num: tempSub!)
        }
        
        //Make Prefix
        let nSPrefix=NSString(string: BinaryIP)
        var userPrefix = nSPrefix.substring(to:prefixLength!)
        
        
        //Linear --------------
//        let bmp=linearSearch(prefixTable: prefixTable, forPrefix: userPrefix, prefixLength: prefixLength!)
        
        //Binary --------------
        
        let bmp=binarySearch(seedPrefixTable: prefixTable, forPrefix: userPrefix, prefixLength: prefixLength!)
        
        let bmp_id = searchHash(prefix: bmp, list: sortedIPs)
        
        if bmp_id != nil {
            let bmp_entry=sortedIPs[bmp_id!]
            print("source:\(bmp_entry.rawIP!),length:\(bmp_entry.length!),dest:\(bmp_entry.destIP!)")
        } else {
            print("Not Find")
        }
        
        // #time
        endTime=clock()
        
        // #time
        let searchTime=endTime-startTime
        print("Search Time:\(Double(searchTime)/Double(CLOCKS_PER_SEC))")

    }
    
    

}











