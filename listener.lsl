integer gTChan;
integer gLisn;
default{
      state_entry()    
      {
         gTChan = (integer)("0xF" + llGetSubString(llGetKey(),0,6));    
      }   
       touch_end(integer num)    
      {        
        llListenRemove(gLisn);        
        gLisn = llListen(gTChan,"",llDetectedKey(0),"");        
        llTextBox(llDetectedKey(0)," \nType your suggestion and click \"Submit\".",gTChan);        
        llSetTimerEvent(120.0);    
        }        
        listen( integer channel, string name, key id, string msg)    
        {       
          llListenRemove(gLisn);        
          llSetTimerEvent(0.0);        
          llInstantMessage(llGetOwner(), llKey2Name(id) + ": " + msg);        
          llRegionSayTo(id,0,"Thank you. Your message has been sent.");    
          }        
          timer()    
          {        
            llSetTimerEvent(0.0);        
            llListenRemove(gLisn);    
          }
        }
