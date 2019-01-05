VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Store"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

'���i�I��\���N���X�BItemn�̏W����\���R���N�V���������A�[�i�A�̔��A�l�����A�p�������s�����\�b�h�����B

Private m_items As Collection
Private m_salesNum As Integer
Private m_salesPrice As Integer
Private m_priceCutNum As Integer
Private m_customerNum As Integer
Private m_discardNum As Integer
Private id As Integer


Private Sub Class_Initialize()
    Set m_items = New Collection
    id = 0
End Sub


'�������ꂽ���i�𐶐����ĒI�ɕ��ׂ�
'�{���ł���΁A�����͕ʂ̃N���X/���\�b�h�ł��ׂ��ȋC�����邪�N���X����}����ׂɎ�芸���������œZ�߂Ă���B
Public Sub DisplayItems(num As Integer)

    Dim i As Integer
    For i = 0 To num - 1
        Dim item_ As Item
        Set item_ = New Item
        m_items.Add item_, CStr(id)
        id = id + 1
    Next i
        PrintItems
End Sub

'���q�l�����X����V�[����\���B
'�����̔̔������Z�o���A�����o�ϐ��ɕۑ�
Public Sub ComingCustomer()
 
    Dim Customers As Collection
    
    Const max = 10
    Const min = 5
    Randomize
    
    m_customerNum = 0
    m_customerNum = Int((max - min + 1) * Rnd + min)
    
    m_salesPrice = 0 '���񏉊������Ȃ��ƑO�̓��̕����c�����܂܂ɂȂ�B
    
    Dim decideSales_ As Integer
    Dim i As Integer
    For i = 0 To m_customerNum
        Dim customer_ As Customer
        Set customer_ = New Customer
        decideSales_ = decideSales_ + customer_.BuyItems
        m_salesPrice = m_salesPrice + customer_.GetPay '��l������̎x������l�����A���v���ă����o�ϐ��ɕۑ��B
    Next i
    m_salesNum = decideSales_
    
End Sub

'�������ܖ������̏��i���Q�O�~�l�������āA���ʂ������o�ϐ��ɕۑ�����B
'���N���X����l���������Ăяo���Ƃ���func GetPriceCutNum()���ĂԁB(��������̂܂܂Q��ĂԂƃo�O�邽�߁j
Public Sub PriceCutItems()

  Dim priceCutNum As Integer
  Dim i As Integer
  Dim item_ As Item
  Dim date_ As Date
  
  date_ = Main.GetIndicator.GetRecord.GetDate
  date_ = DateAdd("d", 1, date_)
  
  For i = m_items.Count - 1 To 1 Step -1
    Set item_ = m_items.Item(i)
    If item_.GetLimit = date_ Then
        item_.PriceDown (20)
        priceCutNum = priceCutNum + 1
    End If
  Next i
  m_priceCutNum = priceCutNum
  PrintItems
End Sub

'�������ܖ������̏��i��p������
Public Sub DiscardItems()

  Dim i As Integer
  Dim item_ As Item
  
  m_discardNum = 0
  
  For i = m_items.Count - 1 To 1 Step -1
    Set item_ = m_items.Item(i)
    If item_.GetLimit = Main.GetIndicator.GetRecord.GetDate Then
        m_items.Remove (i)
        m_discardNum = m_discardNum + 1
    End If
  Next i

  PrintItems
End Sub


'���݂̍݌ɏ󋵂�Main�V�[�g�ɓ]�L����
Private Sub PrintItems()
    Dim ws As Worksheet
    Set ws = Worksheets("main")

    Dim i As Integer
    
    For i = 1 To 100
        ws.Cells(MAIN_ROW.ITEMS + i, MAIN_COLUMN.number).ClearContents
    Next i
    
    Dim item_ As Item
    For i = 1 To m_items.Count
        Set item_ = m_items.Item(i)
        ws.Cells(MAIN_ROW.ITEMS + i, MAIN_COLUMN.number) = item_.GetLimit
        ws.Cells(MAIN_ROW.ITEMS + i, MAIN_COLUMN.Price) = item_.GetPrice
    Next i
End Sub

Public Function GetItems() As Collection
    Set GetItems = m_items
End Function
Public Function GetSalesPrice() As Integer
    GetSalesPrice = m_salesPrice
End Function
Public Function GetPriceCutNum() As Integer
    GetPriceCutNum = m_priceCutNum
End Function
Public Function GetCustomerNum() As Integer
    GetCustomerNum = m_customerNum
End Function
Public Function GetSalesNum() As Integer
    GetSalesNum = m_salesNum
End Function
Public Function GetDiscardNum() As Integer
    GetDiscardNum = m_discardNum
End Function
