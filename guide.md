Assignment 1 — Custom Filter Bar Extensions (Fiori Elements V4)
Khoá học: SAP Fiori Elements V4 — Extension Patterns Entity tham khảo: Travel (OData V4) Backend: Mỗi học viên tự deploy 1 project BE riêng dựa trên source code BE đính kèm (file zip). Output: App Fiori Element List Report với 4 tính năng custom.

0. Mục tiêu học tập (Learning Outcome)
Sau khi hoàn thành assignment này, học viên phải:

Hiểu được 3 cấp Extension của Fiori Elements V4 — Manifest Config → Controller Extension → Custom Fragment.
Biết extend ListReport Controller đúng pattern và đăng ký qua manifest.json.
Đọc/Ghi state của MDC FilterBar bằng API chuẩn — không hack DOM.
Khai báo Custom Filter Field không tồn tại trong CDS annotation.
Dynamic UI rendering với JSONModel + expression binding.
Không phá clean core — toàn bộ customization nằm trong app project, không sửa annotation BE.
📚 Tài liệu tham khảo cốt lõi (đọc trước khi bắt đầu): - Extending Fiori Elements V4 — SAP Help - Flexible Programming Model Explorer - Guidance on Extensibility

1. Phase 1 — Deploy BE & Generate UI bằng SAP BAS
1.1. Source BE
Source code BE đã được zip và gửi ở file đính kèm.
Mỗi học viên tự deploy 1 project BE riêng trong ABAP Environment / Steampunk của mình.
Tham khảo cấu trúc và logic từ file đính kèm — không bắt buộc giữ nguyên tên field/entity nếu muốn customize.
1.2. Các bước generate UI (ví dụ)
#	Việc cần làm	Ghi chú
1	Mở BAS, vào Dev Space type SAP Fiori.	—
2	Chạy generator: Ctrl+Shift+P → Fiori: Open Application Generator.	Chọn template List Report Page V4.
3	Chọn data source = OData service của BE mà mình đã deploy ở Phase 1.	Service URL tuỳ theo project BE của mỗi học viên.
4	Main Entity = Travel (ví dụ). Module name = assignment1 (ví dụ). Namespace để trống.	Tên tuỳ ý từng học viên.
5	Hoàn tất generator → mở project → npm install → npm run start-mock (chạy với mock data) hoặc npm start (chạy thật).	—
1.3. Acceptance Criteria — Phase 1
App chạy được trên BAS Preview, hiển thị List Report của entity chính.
FilterBar có Search field + một vài field từ annotation UI.SelectionFields.
Table hiển thị cột theo annotation UI.LineItem.
1.4. Demo
(Cap màn hình bước generate + screen app chạy lần đầu — để ảnh ở đây) Initial App

sau khi ấn Go
2. Phase 2 — Implement 4 Custom Tasks
⚠️ Không sửa file annotation/metadata BE. Tất cả customization phải nằm trong webapp/ext/ + webapp/manifest.json.

Cấu trúc thư mục đề xuất
webapp/
├── manifest.json                              ← Đăng ký extension + header actions
└── ext/
    ├── ListReport/
    │   └── <TênListReport>.controller.js       ← Controller Extension (Task 3, 4)
    ├── controller/
    │   ├── <TênChứcNăngClean>.js              ← Task 1
    │   ├── <TênChứcNăngExport>.js             ← Task 2
    │   └── <TênChứcNăngOptions>.js            ← Task 4
    └── fragment/
        ├── <TênFragmentExport>.fragment.xml   ← Task 2 (UI dialog)
        └── <TênFragmentCustomFilter>.fragment.xml  ← Task 3, 4 (UI checkbox/radio/segmented)
Tên file do học viên tự đặt — ưu tiên đặt tên theo chức năng để code readable.

🟢 Task 1 — Clean Filter Bar Button
Mục đích sư phạm: Nhập môn về extension — kết nối được button trên header với handler, đọc/ghi state FilterBar bằng API chuẩn.

Yêu cầu chức năng: 1. Thêm button "Clean Filter Bar" lên header của List Report. 2. Click → hiện dialog confirm. 3. Nếu OK → clear toàn bộ filter conditions (cả standard + custom field nếu có), reset visual state các FilterField, reset SearchField về rỗng. 4. Refresh table sau khi clear. 5. Toast thông báo thành công.

Acceptance Criteria: - [ ] Nút hiển thị đúng vị trí header. - [ ] Có dialog confirm trước khi clear. - [ ] Sau khi OK, tất cả input trên FilterBar về rỗng. - [ ] Table reload, không còn $filter trong request OData. - [ ] Có toast confirm.

Hint (keyword tham khảo, không phải lời giải): - oExtensionAPI - oFilterBar.getFilterConditions() / setFilterConditions(...) - sap.ui.core.Element.registry.filter(...) - sap.m.MessageBox.confirm(...) / sap.m.MessageToast

Tư duy / Hướng debug: - Khi setFilterConditions({}) mà visual của input chip không tự clear — vì sao? Nó nói gì về cách MDC tách model ↔ rendering? - Custom filter field có thể chứa control sap.m.CheckBox bên trong — khi clear, ai chịu trách nhiệm untick visual đó? - Sau khi clear, table có tự refresh không hay phải gọi API gì?

Tài liệu tự research: - Adding Custom Header Actions — Fiori Elements - sap.ui.mdc.FilterBar — API Reference - sap.m.MessageBox — API Reference

Demo:

(Cap màn hình button + dialog confirm + state trước/sau khi clear — để ảnh ở đây) alt text alt text alt text

🟡 Task 2 — Export Filter Bar Button
Mục đích sư phạm: Học cách inspect runtime state của FilterBar từ nhiều nguồn (Extension API vs MDC API), load Fragment programmatically, hiển thị data qua named model.

Yêu cầu chức năng: 1. Thêm button "Export Filter Bar" trên header. 2. Click → mở Dialog hiển thị: - Tab 1 — Table: bảng field | operator | value của tất cả filter đang active. - Tab 2 — Raw JSON: raw JSON của conditions để debug. 3. Nút "Copy JSON" copy raw JSON vào clipboard. 4. Nút "Close" đóng dialog. 5. Dialog phải được cache (không load lại fragment mỗi lần mở).

Acceptance Criteria: - [ ] Dialog mở được, có 2 tab. - [ ] Filter conditions hiển thị đúng — cả filter standard lẫn custom. - [ ] Operator hiển thị đúng (EQ, NE, BT, ...). - [ ] Copy JSON hoạt động. - [ ] Mở/đóng nhiều lần không tạo dialog mới.

Hint (keyword tham khảo): - oExtensionAPI.getFilters() - oFilterBar.getFilterConditions() - sap.ui.core.Fragment.load(...) - oExtensionAPI.addDependent(...) - navigator.clipboard.writeText(...)

Tư duy / Hướng debug: - Có 2 nguồn đọc filter — chúng khác nhau ở đâu? Cái nào đầy đủ hơn? Tại sao SAP lại có 2? - Object Filter của UI5 có cấu trúc cây lồng nhau (aFilters đệ quy) — làm sao flatten ra để hiển thị thành bảng? - Nếu không cache dialog, mở 10 lần thì sao? Tốn memory ở đâu? - Vì sao phải addDependent dialog vào ExtensionAPI?

Tài liệu tự research: - ListReport Extension API — getFilters - Using Fragments — Programmatic Loading - Working with Dialogs and Fragments

Demo:

(Cap màn hình dialog Export với Table tab + JSON tab — để ảnh ở đây) alt text alt text

alt text
🟠 Task 3 — Custom Filter Field dạng CheckBox
Mục đích sư phạm: Vượt khỏi giới hạn annotation-driven của Fiori Elements — khai báo filter field không tồn tại trong CDS, xây UI bằng fragment, viết handler trong Controller Extension.

Yêu cầu chức năng: 1. Thêm custom filter field tên hiển thị "Custom XX = 90" vào FilterBar. 2. UI của field là CheckBox: - Tick (default khi load) → áp dụng condition customxx EQ 90. - Untick → áp dụng condition customxx NE 90. 3. Khi user nhấn Go → request OData phải có $filter=customxx eq 90 (hoặc ne). 4. Default khi load app: CheckBox đã tick sẵn, table đã filter sẵn.

💡 Note: Field customxx không cần tồn tại trong service thật — đây là exercise về cơ chế. Học viên có thể thay bằng field thật trong entity của mình (vd BookingFee) nếu muốn kiểm tra request thực tế.

Acceptance Criteria: - [ ] FilterBar có thêm field "Custom XX = 90" với CheckBox. - [ ] Load lần đầu → CheckBox tick sẵn, FilterBar hiện condition. - [ ] Tick/untick → request OData đổi đúng (eq ↔ ne). - [ ] Click Clean Filter Bar (Task 1) → CheckBox untick + condition biến mất.

Hint (keyword tham khảo): - manifest.json → controlConfiguration.@SelectionFields.filterFields - manifest.json → sap.ui5.extends.extensions.sap.ui.controllerExtensions - sap.ui.core.mvc.ControllerExtension.extend(...) - override.onAfterRendering - Property validated: "Validated" trong condition object

Tư duy / Hướng debug: - Key của filterField (vd customxx-Bool) khác tên field OData — vì sao tách 2 cái này? Có rule mapping nào không? - Tại sao có condition rồi mà Network tab không thấy $filter? MDC có cờ nào để phân biệt "đang gõ dở" vs "đã commit"? - Đăng ký Controller Extension trong manifest — key có format <Controller>#<AppId>::<TargetId>. Sai 1 ký tự → hậu quả gì? Cách debug? - Set default condition ở onInit vs onAfterRendering — khác nhau ra sao? Lifecycle nào FilterBar đã ready?

Tài liệu tự research: - Adding Custom Filter Fields - Controller Extension — How to Extend - sap.ui.core.mvc.ControllerExtension API - MDC FilterBar — setFilterConditions

Demo:

(Cap màn hình FilterBar có custom field + Network tab show $filter=customxx eq 90 — để ảnh ở đây) alt text alt text

alt text
🔴 Task 4 — Options Button: Dynamic Switch UI Mode của Custom Filter
Mục đích sư phạm: Task tổng hợp — kết hợp Controller Extension public method, JSONModel + expression binding, dynamic UI rendering. Mô phỏng user-configurable UI trong real-world.

Yêu cầu chức năng: 1. Thêm button "Options" trên header. Click → mở Menu với 3 lựa chọn: - CheckBox (default) - RadioButton - Segmented Button 2. Chọn mode → custom filter field của Task 3 đổi UI theo mode: - CheckBox: như Task 3. - RadioButton: 2 radio "= 90" / "≠ 90". - Segmented Button: 2 segment "EQ" / "NE". 3. Đổi mode → reset condition về EQ 90 (UI mới luôn ở default). 4. Tick checkbox / chọn radio / chọn segment → đều ghi condition tương ứng vào FilterBar.

💎 Bonus (optional): Persist mode đã chọn (localStorage hoặc Personalization service) để mở lại app vẫn nhớ mode cũ.

Acceptance Criteria: - [ ] Click Options → menu hiện 3 lựa chọn. - [ ] Chọn mode khác → UI fragment đổi đúng control. - [ ] Mỗi lần đổi mode → condition reset về EQ 90. - [ ] Click Go → request OData đúng với mode đang active.

Hint (keyword tham khảo): - sap.m.Menu + sap.m.MenuItem - JSONModel (named model uiMode) gắn vào FilterBar - Expression binding: visible="{= ${uiMode>/customXxMode} === 'radio' }" - Public method trên Controller Extension cho OptionsMenu gọi - oController.getExtensionByName(...)

Tư duy / Hướng debug: - Có 1 fragment chứa 3 control với visible binding vs 3 fragment riêng dynamic load — pros/cons? - Model uiMode phải gắn vào đâu để binding {uiMode>/...} trong fragment con resolve được? Có thể gắn vào View, Component, FilterBar — đâu là chỗ "đúng"? - Đổi mode mà không reset condition → bug gì xảy ra với UI state vs data state? - OptionsMenu là module độc lập, làm sao gọi được method trên Controller Extension? Có 3 hướng tiếp cận — chọn cái nào và vì sao? - Sau khi setProperty để đổi mode, control mới render xong chưa chắc đã sync state — cần kỹ thuật gì để đợi render cycle?

Tài liệu tự research: - Expression Binding - JSONModel - sap.m.Menu API - Controller Extension — Calling Methods - User Personalization Service (Bonus)

Demo:

(Cap nhiều màn hình: menu 3 options + UI từng mode CheckBox / Radio / Segmented + Network tab khi chọn từng mode — để ảnh ở đây) alt text alt text alt text alt text

alt text
3. Tiêu chí chấm điểm (Rubric)
#	Task	Trọng số	Tiêu chí pass
1	Phase 1 — Generate UI từ BAS	10%	App chạy được, hiển thị List Report
2	Task 1 — Clean Filter Bar	15%	Clear cả standard + custom + visual + table refresh
3	Task 2 — Export Filter Bar	20%	Dialog có Table + JSON, copy hoạt động, dialog cached
4	Task 3 — Custom CheckBox Filter	25%	Default tick, condition đúng EQ/NE, request OData đúng
5	Task 4 — Options Menu dynamic	25%	3 mode switch được, condition reset đúng, UI render đúng
6	Code quality	5%	JSDoc, console log có prefix, không hardcode magic string
