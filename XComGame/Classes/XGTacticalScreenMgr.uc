class XGTacticalScreenMgr extends Actor;

struct TText
{
    var string StrValue;
    var int iState;

    structdefaultproperties
    {
        StrValue=""
        iState=0
    }
};

struct TLabeledText
{
    var string StrValue;
    var string strLabel;
    var int iState;
    var bool bNumber;

    structdefaultproperties
    {
        StrValue=""
        strLabel=""
        iState=0
        bNumber=false
    }
};



DefaultProperties
{
}
