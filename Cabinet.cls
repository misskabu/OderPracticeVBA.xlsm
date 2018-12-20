VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Cabinet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

'���i�I��\���N���X�BItemn�̏W����\���R���N�V���������A�[�i�A�̔��A�l�����A�p�������s�����\�b�h�����B

Private m_items As Collection
Private m_salesNum As Integer
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

'�̔����������i�I�������
'@return �̔���
Public Function SellItems() As Integer

    Dim i As Integer
    Dim item_ As Item
    For i = m_salesNum To 1 Step -1
        Set item_ = m_items.Item(i)
        m_items.Remove (i)
        SellItems = SellItems + 1
    Next i
    
    PrintItems
End Function
'�����̔̔����z���J�E���g
'@return �̔����z
Public Function CountSalesPrice() As Integer

    Dim i As Integer
    Dim item_ As Item
    For i = DecideSales To 1 Step -1
        Set item_ = m_items.Item(i)
        CountSalesPrice = CountSalesPrice + item_.GetPrice '�̔����z�����Z
    Next i
      
End Function
'�����̔̔������Z�o����B�Ƃ肠���������_���Ȓl���o���Ă��邾���B
Private Function DecideSales() As Integer
    Dim max As Integer
    Dim min As Integer
    Dim ws As Worksheet
    Set ws = Worksheets("data")

    max = ws.Cells(4, 10)
    min = ws.Cells(3, 10)
    
    Randomize
    m_salesNum = Int((max - min + 1) * Rnd + min)
    DecideSales = m_salesNum
    
End Function

'�������ܖ������̏��i���Q�O�~�l����
'@return �l������
Public Function PriceCutItems() As Integer
    
  Dim priceCutNum As Integer
  Dim i As Integer
  Dim item_ As Item
  For i = m_items.Count - 1 To 1 Step -1
    Set item_ = m_items.Item(i)
    If item_.GetLimit = Main.GetIndicator.GetRecord.GetDate Then
        item_.PriceDown (20)
        priceCutNum = priceCutNum + 1
    End If
  Next i
  PriceCutItems = priceCutNum
  PrintItems
  Debug.Print "Cabinet:PriceCutItems$ priceCut=", priceCutNum
End Function

'�������ܖ������̏��i��p��
'@return �p����
Public Function DiscardItems() As Integer
    
  Dim discardNum As Integer
  Dim i As Integer
  Dim item_ As Item
  For i = m_items.Count - 1 To 1 Step -1
    Set item_ = m_items.Item(i)
    If item_.GetLimit = Main.GetIndicator.GetRecord.GetDate Then
        m_items.Remove (i)
        discardNum = discardNum + 1
    End If
  Next i
  DiscardItems = discardNum
  PrintItems
  Debug.Print "Cabinet:DiscardItems$ loss=", discardNum
End Function


'���݂̍݌ɏ󋵂�Main�V�[�g�ɓ]�L����
Private Sub PrintItems()
    Dim ws As Worksheet
    Set ws = Worksheets("main")

    Dim i As Integer
    
    For i = 1 To 100
        ws.Cells(MAIN_ROW.ITEMS + i, MAIN_COLUMN.Number).ClearContents
    Next i
    
    Dim item_ As Item
    For i = 1 To m_items.Count
        Set item_ = m_items.Item(i)
        ws.Cells(MAIN_ROW.ITEMS + i, MAIN_COLUMN.Number) = item_.GetLimit
        ws.Cells(MAIN_ROW.ITEMS + i, MAIN_COLUMN.Price) = item_.GetPrice
    Next i
End Sub

